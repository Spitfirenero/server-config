{ pkgs, ... }:

{
  services.tailscale.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  systemd.services.tailscale-udp-gro = {
    description = "Configure UDP GRO forwarding for Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.ethtool}/bin/ethtool -K enp0s31f6 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  systemd.services.tailscale-exit-node = {
    description = "Advertise Tailscale exit node";
    after = [ "network-online.target" "tailscaled.service" "tailscale-udp-gro.service" ];
    wants = [ "network-online.target" "tailscaled.service" "tailscale-udp-gro.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 10;
      ExecStart = ''
        ${pkgs.bash}/bin/bash -euo pipefail -c '
          for _ in $(seq 1 30); do
            if ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; then
              exec ${pkgs.tailscale}/bin/tailscale up --advertise-exit-node
            fi
            sleep 2
          done
          echo "tailscaled was not ready in time" >&2
          exit 1
        '
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
