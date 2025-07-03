{config, pkgs, ...}: {
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };
  
  environment.systemPackages = [
    pkgs.zsh-powerlevel10k
  ];

  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  users.defaultUserShell = pkgs.zsh;
}