{ ... }:

{
  # Use the repository encrypted files as the source (`sopsFile`) and write
  # decrypted secrets to absolute paths under `/etc/sops/secrets/` so the
  # installer doesn't try to overwrite files inside the Nix store/source.
  sops.defaultSopsFile = builtins.toString ../secrets/nextcloud.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.validateSopsFiles = true;

  sops.age.sshKeyPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  sops.secrets.nextcloud-admin-pass = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
    # Target path on the running system where the decrypted secret will live
    path = "/etc/sops/secrets/nextcloud-admin-pass.yaml";
    # Source encrypted file in the repo (Nix store path)
    sopsFile = builtins.toString ../secrets/nextcloud.yaml;
  };

  sops.secrets.cloudflare-dns-api-token = {
    owner = "acme";
    group = "acme";
    mode = "0400";
    # Target path on the running system for ACME to read
    path = "/etc/sops/secrets/cloudflare-dns-api-token.yaml";
    sopsFile = builtins.toString ../secrets/cloudflare-dns-api-token.yaml;
  };
}