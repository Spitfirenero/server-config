{ pkgs, ... }:

{
  services.tailscale.enable = true;

  # Exit node mode requires packet forwarding.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  systemd.services.tailscale-exit-node = {
    description = "Advertise Tailscale exit node";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.tailscale}/bin/tailscale up --advertise-exit-node
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
