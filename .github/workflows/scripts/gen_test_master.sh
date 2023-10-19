#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}
PROJECT_DIR=$SCRIPT_DIR/../../../
GENERATED_WORKFLOW="$SCRIPT_DIR/../test_master.yml"

function printJobForRole {
  export JOBNAME=$1
  export JOB_CMD=".test/test_role.sh $1 -vvv"

  envsubst < "$SCRIPT_DIR/job.template"
}

function printJobForCustomTest {
  export JOBNAME=$1
  export JOB_CMD=".test/$1/test.sh -vvv"

  envsubst < "$SCRIPT_DIR/job.template"
}

function printAllRoleTests() {
  find "$PROJECT_DIR/roles" -mindepth 1 -maxdepth 1 -type d -print0 |
      while IFS= read -r -d '' line; do
          role=$(echo "$line" | sed -E 's$.*/([^/]+)$\1$')
          if [ "$role" != '_copy_template' ]
          then
            printJobForRole "$role"
          fi
      done
}

function printAllCustomTests() {
  find "$PROJECT_DIR/.test" -mindepth 1 -maxdepth 1 -type d -print0 |
      while IFS= read -r -d '' line; do
        custom_test=$(echo "$line" | sed -E 's$.*/([^/]+)$\1$')
        if [ "$custom_test" != 'docker' ]
        then
          printJobForCustomTest "$custom_test"
        fi
      done
}

function generateWorkflow() {
    cat "$SCRIPT_DIR/workflow.template"
    echo "# ROLE TESTS"
    printAllRoleTests
    echo "# CUSTOM TESTS"
    printAllCustomTests
}


CHECKSUM_PRE_RUN=$(sha256sum "$GENERATED_WORKFLOW")

generateWorkflow > "$GENERATED_WORKFLOW"

CHECKSUM_POST_RUN=$(sha256sum "$GENERATED_WORKFLOW")



echo "CHECKSUM_PRE_RUN:   $CHECKSUM_PRE_RUN"
echo "CHECKSUM_POST_RUN:  $CHECKSUM_POST_RUN"
if [ "$CHECKSUM_PRE_RUN" != "$CHECKSUM_POST_RUN" ]
then
  echo "checksums changed."
  echo "returning status code 1 to make post-commit-hook interrupt commits"
  printf "\n\n%s\n" "the github workflow 'test_master.yml' has been updated. review and add to the commit"
  exit 1
fi
