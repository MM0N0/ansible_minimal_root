let
    fixed_pkgs = import ./pinned.nix;
in
[
    fixed_pkgs.coreutils
    fixed_pkgs.bash
    fixed_pkgs.acl

    fixed_pkgs.ansible_2_13
    fixed_pkgs.sshpass

    fixed_pkgs.pre-commit
    fixed_pkgs.envsubst
]
