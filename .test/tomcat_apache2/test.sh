#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}
PROJECT_DIR=$SCRIPT_DIR/../../

if [ -n "$ANSIBLE_TEST_STOP_CONTAINER" ]; then
  ANSIBLE_TEST_STOP_CONTAINER=1
fi
if [ -z "$ANSIBLE_TEST_REMOVE_ROOT" ]; then
  ANSIBLE_TEST_REMOVE_ROOT=1
fi

printf "\n[run test 'tomcat_apache']\n\n"

if [ "$ANSIBLE_TEST_STOP_CONTAINER" == 1 ]; then
  docker compose -f "$SCRIPT_DIR/docker-compose.yml" down > /dev/null 2>&1 || echo "no running container"
fi

# to make script abort, when any command fails
set -e
set -o pipefail

docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d



echo "do root-tasks"
ROOT_TASKS_CMD="ansible-playbook -i '$SCRIPT_DIR/inventory.yml' '$SCRIPT_DIR/test.yml' --tags all_roles,root_tasks $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$ROOT_TASKS_CMD"

if [ "$ANSIBLE_TEST_REMOVE_ROOT" == 1 ]; then
  echo "remove root"
  REMOVE_ROOT_CMD="ansible-playbook -i '$SCRIPT_DIR/inventory.yml' '$PROJECT_DIR/.test/remove_sudo_permissions.yml' -e 'set_hosts=all,!localhost' $2"
  "$PROJECT_DIR/.docker/ansible_docker.sh" "$REMOVE_ROOT_CMD"
else
  echo "skipped remove root"
fi

echo "do non-root-tasks"
NON_ROOT_TASKS_CMD="ansible-playbook -i '$SCRIPT_DIR/inventory.yml' '$SCRIPT_DIR/test.yml' --tags all_roles,non_root_tasks $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$NON_ROOT_TASKS_CMD"

echo "do test-tasks"
TEST_TASKS_CMD="ansible-playbook -i '$SCRIPT_DIR/inventory.yml' -e 'ansible_user=root ansible_password=root' '$SCRIPT_DIR/test.yml' $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$TEST_TASKS_CMD"



if [ "$ANSIBLE_TEST_STOP_CONTAINER" == 1 ]; then
  echo "stopping container"
  docker compose -f "$SCRIPT_DIR/docker-compose.yml" down
fi
