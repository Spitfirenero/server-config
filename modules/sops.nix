{ ... }:

{
  # Use explicit secret files instead of a single defaultSopsFile to allow
  # splitting secrets across multiple encrypted files. Set a harmless absolute
  # path so the option type (absolute path) is satisfied; we rely on explicit
  # `path` entries below instead of the default file.
  sops.defaultSopsFile = "/dev/null";
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  sops.secrets.nextcloud-admin-pass = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
    path = builtins.toString ../secrets/nextcloud.yaml;
  };

  sops.secrets.cloudflare-dns-api-token = {
    owner = "acme";
    group = "acme";
    mode = "0400";
    path = builtins.toString ../secrets/cloudflare-dns-api-token.yaml;
  };
}