{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # discord
    # (discord.override {
    #   withOpenASAR = true;

    #   withVencord = true;
    # })
    vesktop
  ];
}
