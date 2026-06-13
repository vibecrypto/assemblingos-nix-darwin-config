# `assemblingos-update`: the maintainer "bump + release" command.
#
# Flow: sync repo -> update flake inputs -> build (nothing applied yet) -> only
# on a successful build, switch the live system -> commit & push the new
# flake.lock so other AssemblingOS machines can pull the same versions.
#
# This is the on-demand counterpart to assemblingos.autoUpgrade (the scheduled
# fleet/pull rebuild). Override the repo location with $ASSEMBLINGOS_REPO.
{ pkgs, ... }:
let
  assemblingos-update = pkgs.writeShellApplication {
    name = "assemblingos-update";
    runtimeInputs = [ pkgs.git ];
    text = ''
      set -euo pipefail
      # Determinate Nix + the active system provide nix / darwin-rebuild.
      export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

      repo="''${ASSEMBLINGOS_REPO:-$HOME/nix-darwin-config}"
      cd "$repo" || { echo "Config repo not found: $repo" >&2; exit 1; }

      if [ "$(uname -s)" = "Darwin" ]; then
        rebuild="darwin-rebuild"
        host="$(scutil --get LocalHostName)"
      else
        rebuild="nixos-rebuild"
        host="$(hostname)"
      fi

      echo "==> AssemblingOS update for $host (repo: $repo)"

      echo "==> Syncing repo"
      git pull --rebase --autostash || true

      echo "==> Updating flake inputs (newer nixpkgs etc.)"
      nix flake update

      echo "==> Building — nothing is applied yet"
      if ! "$rebuild" build --flake ".#$host"; then
        echo "!! Build failed after the flake update. NOT switching." >&2
        echo "   Revert the update with: git -C $repo checkout flake.lock" >&2
        exit 1
      fi

      echo "==> Build OK. Switching the live system (needs sudo)"
      sudo "$rebuild" switch --flake ".#$host"

      if git diff --quiet -- flake.lock; then
        echo "==> Already current; nothing new to release"
      else
        echo "==> Recording + releasing the update"
        git add flake.lock
        git commit -m "chore: flake update $(date +%F)"
        git push || echo "!! Push failed (no rights or remote ahead); commit kept locally" >&2
      fi

      echo "==> Done. Enjoy your coffee."
    '';
  };
in
{
  environment.systemPackages = [ assemblingos-update ];
}
