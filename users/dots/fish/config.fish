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
