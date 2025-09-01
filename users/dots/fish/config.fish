alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

alias system="sudo nixos-rebuild --log-format bar --no-reexec --file ~/nixos -A nixosConfigurations.$prompt_hostname"

alias ls="eza --icons --group-directories-first -1"

set sponge_purge_only_on_exit true
set fish_greeting
set fish_cursor_insert line blink
fish_vi_key_bindings

function fish_mode_prompt -d "remove vi mode indicators"; end

set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)
