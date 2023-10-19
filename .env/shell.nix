let
    pkgs = import <nixpkgs> {};
    fixed_pkgs = import (builtins.fetchGit {
        name = "fixed-project-revision";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-23.05-darwin";
        rev = "48e82fe1b1c863ee26a33ce9bd39621d2ada0a33";
    }) {};
in
pkgs.mkShell {
    buildInputs = [
        fixed_pkgs.ansible_2_13
        fixed_pkgs.sshpass

        fixed_pkgs.pre-commit
        fixed_pkgs.envsubst
    ];

    # Env vars
    ANSIBLE_CONFIG=".docker/ansible.cfg";
}

# you may have to:
# sudo apt install python3-cffi-backend
