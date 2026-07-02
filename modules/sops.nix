{ ... }:

{
  # Use the encrypted files that live on the target system under
  # `/etc/nixos/secrets/` as the `sopsFile` sources. Disable strict
  # validation so Nix doesn't require these to be present in the Nix store.
  sops.defaultSopsFile = "/etc/nixos/secrets/nextcloud.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.validateSopsFiles = false;

  sops.age.sshKeyPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  sops.secrets.nextcloud-admin-pass = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
    # Target path on the running system where the decrypted secret will live
    path = "/etc/sops/secrets/nextcloud-admin-pass.yaml";
    # Source encrypted file on the running system
    sopsFile = "/etc/nixos/secrets/nextcloud.yaml";
  };

  sops.secrets.cloudflare-dns-api-token = {
    owner = "acme";
    group = "acme";
    mode = "0400";
    # Target path on the running system for ACME to read
    path = "/etc/sops/secrets/cloudflare-dns-api-token.yaml";
    # Source encrypted file on the running system
    sopsFile = "/etc/nixos/secrets/cloudflare-dns-api-token.yaml";
  };
}