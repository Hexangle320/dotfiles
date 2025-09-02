alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

alias system="sudo nixos-rebuild --log-format bar --no-reexec --file ~/nixos -A nixosConfigurations.$prompt_hostname"

alias ls="eza --icons --group-directories-first -1"

bind --mode insert alt-f 'fzf-file-widget'

set sponge_purge_only_on_exit true
set fish_greeting
set fish_cursor_insert line blink
fish_vi_key_bindings

set -g hydro_symbol_start
set hydro_symbol_git_dirty "*"
set fish_prompt_pwd_dir_length 0
function fish_mode_prompt -d "remove vi mode indicators"; end

if test -n "$IN_NIX_SHELL";
  set -g hydro_symbol_start "<nix-shell> "
else
  set -g hydro_symbol_start
end
