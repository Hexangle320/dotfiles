{
  lib,
  pkgs,
  config,
  ...
}: {
  users.users.root.shell = pkgs.fish;
  documentation.man.generateCaches = false;
  programs.fish = {
    enable = true;
    useBabelfish = true;
    generateCompletions = false;
  };

  programs = {
    direnv.enableFishIntegration = true;
    command-not-found.enable = false;
    fzf.keybindings = true;
  };

  environment.systemPackages = lib.attrValues {
    inherit (pkgs.fishPlugins) sponge hydro;
    inherit (pkgs) eza fish-lsp;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
