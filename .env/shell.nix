let
    fixed_pkgs = import ./pinned.nix;
    fixed_packages = import ./packages.nix;
in
fixed_pkgs.mkShell {
    buildInputs = fixed_packages;

    # Env vars
    ANSIBLE_CONFIG=".docker/ansible.cfg";
}
# you may have to:
# sudo apt install python3-cffi-backend
