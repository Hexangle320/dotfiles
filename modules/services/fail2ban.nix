{
  lib,
  pkgs,
  ...
}: {
  services.fail2ban = {
    enable = true;
   # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      "100.64.0.0/10" # Tailscale
      "127.0.0.1/8"
    ];
    bantime = "48h"; # Ban IPs for two days on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "1y";
      overalljails = true;
    };
  };
}
