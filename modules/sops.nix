{ ... }:

{
  sops.defaultSopsFile = ../secrets/nextcloud.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  sops.secrets.nextcloud-admin-pass = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
  };
}