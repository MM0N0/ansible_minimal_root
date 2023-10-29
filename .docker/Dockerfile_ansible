FROM nixos/nix
RUN nix-channel --update

WORKDIR /tmp
COPY ../.env .env
RUN nix-env -if /tmp/.env/packages.nix && nix-collect-garbage -d && rm -Rf /root/.cache/nix


ENV ANSIBLE_CONFIG=.docker/ansible.cfg
ENV ANSIBLE_DEBUG=0
ENV ANSIBLE_FORCE_COLOR=True
