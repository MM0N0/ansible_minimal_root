#!/usr/bin/env bash
if [ -z "$NO_TTY" ]; then
  NO_TTY="0"
fi
INTERACTIVE_ARG=" -it"
if [ "$NO_TTY" == "1" ]; then
  INTERACTIVE_ARG=""
fi

if [ -z "$SSH_KEY_FILE" ]; then
  SSH_KEY_FILE=""
fi

docker run --rm$INTERACTIVE_ARG --net="host" --name=dev_docker_ansible_minimal_root \
  -v "${PWD}":/repo:rw \
  -v ~/.ansible:/root/.ansible \
  --mount type=tmpfs,destination=/ramdisk \
  "mm0n0/dev_docker_ansible_minimal_root:v1" \
  \
  bash -c \
    "cd /repo && \

    SSH_KEY_FILE=$SSH_KEY_FILE \
    ANSIBLE_VAULT_PASS_user_vault=$(cat "$ANSIBLE_VAULT_PASS_FILE_user_vault" 2> /dev/null) \
    bash .docker/inject_credentials_then_run.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}"
