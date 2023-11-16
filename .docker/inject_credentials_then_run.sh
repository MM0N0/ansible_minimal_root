##!/usr/bin/env bash
function cache_vault_pass() {
    VAULT_ID="$1"
    VAULT_PASS_FILE="/ramdisk/$VAULT_ID"

    VAULT_PASS_ENV_VAR_NAME="ANSIBLE_VAULT_PASS_$VAULT_ID"

    if [[ -n ${!VAULT_PASS_ENV_VAR_NAME} && $VAULT_PASS_ENV_VAR_NAME != "" ]]; then
      declare -n VAULT_PASS_ENV_VAR_NAME="$VAULT_PASS_ENV_VAR_NAME"
      echo "${PS1}found pass for vault with id '$VAULT_ID'";
      VAULT_PASS=${VAULT_PASS_ENV_VAR_NAME}
    else
      read -r -s -p "[$VAULT_ID] type vault password: " VAULT_PASS
      echo ""
    fi

    echo "$VAULT_PASS" > "$VAULT_PASS_FILE"
    ANSIBLE_VAULT_IDENTITY_LIST="$ANSIBLE_VAULT_IDENTITY_LIST,$VAULT_PASS_FILE"
}
function inject_key_into_docker() {
  SSH_KEY_FILE=$1

  mkdir /root/.ssh;
  chmod 700 /root/.ssh;
  cat "$SSH_KEY_FILE" > /root/.ssh/id_rsa;
  printf 'IdentityFile /root/.ssh/id_rsa' > /root/.ssh/config;
  cat "$HOME/.ssh/known_hosts" > /root/.ssh/known_hosts;
  chmod 600 /root/.ssh/*;
  eval \`ssh-agent\`;
  ssh-add /root/.ssh/id_rsa;
}

# set custom prompt
export PS1='[ansible_minimal_root] '

# injecting SSH KEY
if [ "$SSH_KEY_FILE" != "" ]; then
  echo "${PS1}injecting ssh key '$SSH_KEY_FILE'"
  inject_key_into_docker "$SSH_KEY_FILE"
else
  echo "${PS1}no ssh key file provided"
fi

# injecting passwords for vaults
export ANSIBLE_VAULT_IDENTITY_LIST
# uncomment to: enable vault password prompt for vault id 'proj_bar'
#cache_vault_pass "proj_bar" "ANSIBLE_VAULT_PASS_proj_bar";
#cache_vault_pass "user_vault" "$ANSIBLE_VAULT_PASS_user_vault";


$1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}
