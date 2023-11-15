#!/usr/bin/env bash
if [ -z "$NO_TTY" ]; then
  NO_TTY="0"
fi
INTERACTIVE_ARG=" -it"
if [ "$NO_TTY" == "1" ]; then
  INTERACTIVE_ARG=""
fi

docker run --rm$INTERACTIVE_ARG --net="host" --name=ansible_docker \
  -v "${PWD}":/repo:rw \
  -v ~/.ansible:/root/.ansible \
  "mm0n0/ansible_docker:v1" \
  \
  bash -c "
    mkdir -p /tmp &&
    cd /repo &&
    $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}"
