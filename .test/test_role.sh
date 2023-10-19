#!/usr/bin/env bash
ROLE=$1
SCRIPT_DIR=${0%/*}
PROJECT_DIR=$SCRIPT_DIR/../
TEST_DIR=$PROJECT_DIR/roles/$ROLE/tests/


# to make script abort, when any command fails
set -e
set -o pipefail

if [ "$ANSIBLE_RUN_ONLY_TEST_TASKS" == 1 ]; then
  echo "do test-tasks"
  TEST_TASKS_CMD="ansible-playbook -i '$TEST_DIR/inventory.yml' -e 'ansible_user=root ansible_password=root' '$TEST_DIR/test.yml' $2"
  "$PROJECT_DIR/.docker/ansible_docker.sh" "$TEST_TASKS_CMD"
  exit 0
fi

if [ -z "$ANSIBLE_TEST_STOP_CONTAINER" ]; then
  ANSIBLE_TEST_STOP_CONTAINER=1
fi
if [ -z "$ANSIBLE_TEST_REMOVE_ROOT" ]; then
  ANSIBLE_TEST_REMOVE_ROOT=1
fi

if [ "$ANSIBLE_TEST_STOP_CONTAINER" == 1 ]; then
  docker compose -f "$TEST_DIR/docker-compose.yml" down > /dev/null 2>&1 || echo "no running container"
fi

docker compose -f "$TEST_DIR/docker-compose.yml" up -d



echo "do root-tasks"
ROOT_TASKS_CMD="ansible-playbook -i '$TEST_DIR/inventory.yml' '$TEST_DIR/test.yml' --tags all_roles,root_tasks $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$ROOT_TASKS_CMD"

if [ "$ANSIBLE_TEST_REMOVE_ROOT" == 1 ]; then
  echo "remove root"
  REMOVE_ROOT_CMD="ansible-playbook -i '$TEST_DIR/inventory.yml' '$SCRIPT_DIR/remove_sudo_permissions.yml' -e 'set_hosts=all,!localhost' $2"
  "$PROJECT_DIR/.docker/ansible_docker.sh" "$REMOVE_ROOT_CMD"
else
  echo "skipped remove root"
fi

echo "do non-root-tasks"
NON_ROOT_TASKS_CMD="ansible-playbook -i '$TEST_DIR/inventory.yml' '$TEST_DIR/test.yml' --tags all_roles,non_root_tasks $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$NON_ROOT_TASKS_CMD"

echo "do test-tasks"
TEST_TASKS_CMD="ansible-playbook -i '$TEST_DIR/inventory.yml' -e 'ansible_user=root ansible_password=root' '$TEST_DIR/test.yml' $2"
"$PROJECT_DIR/.docker/ansible_docker.sh" "$TEST_TASKS_CMD"



if [ "$ANSIBLE_TEST_STOP_CONTAINER" == 1 ]; then
  echo "stopping container"
  docker compose -f "$TEST_DIR/docker-compose.yml" down
fi
