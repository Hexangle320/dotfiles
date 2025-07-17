{pkgs, ...}: 

{
  fonts = {
    fontDir.enable = true;
    packages =  with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      material-symbols
      material-icons
      fira-sans
      roboto
    ];
  };
}