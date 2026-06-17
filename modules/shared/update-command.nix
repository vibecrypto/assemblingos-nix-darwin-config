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
      built="$(readlink ./result)"

      echo "==> Build OK. Switching the live system (needs sudo)"
      # Don't trust the switch exit code: nix-darwin's app-management activation
      # step can exit non-zero (e.g. `tccutil reset SystemPolicyAppBundles` on
      # TCC-protected notarised apps in /Applications/Nix Apps) even when the
      # rest ran. Confirm success by checking the live system actually became
      # the closure we just built, instead of releasing a lock for a switch
      # that never applied.
      sudo "$rebuild" switch --flake ".#$host" || true

      if [ "$(readlink /run/current-system 2>/dev/null)" != "$built" ]; then
        echo "!! Switch did NOT fully apply: /run/current-system is not the built closure." >&2
        echo "   On macOS this is almost always the App Management permission — the" >&2
        echo "   activation could not modify notarised apps in /Applications/Nix Apps." >&2
        echo "   Grant Full Disk Access (or App Management) to the app running" >&2
        echo "   darwin-rebuild, then re-run. The flake.lock update was NOT released." >&2
        echo "   Revert it with: git -C $repo checkout flake.lock" >&2
        exit 1
      fi
      echo "==> Switch confirmed live."

      if git diff --quiet -- flake.lock; then
        echo "==> Already current; nothing new to release"
      else
        echo "==> Recording + releasing the update"
        git add flake.lock
        git commit -m "chore: flake update $(date +%F)"
        git push || echo "!! Push failed (no rights or remote ahead); commit kept locally" >&2
      fi

      # Homebrew casks + Mac App Store apps aren't pinned by flake.lock (the
      # non-reproducible escape hatch), so the switch's `brew bundle` installs
      # them but never upgrades them. Refresh them here so one "update" keeps the
      # whole machine current — and so you never need an app's own updater.
      # Local-only, after the fleet release; failures here don't fail the update.
      if [ "$(uname -s)" = "Darwin" ]; then
        for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
          if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
        done
        if command -v brew >/dev/null 2>&1; then
          echo "==> Upgrading Homebrew formulae + casks"
          brew update || true
          # --greedy-auto-updates also upgrades casks marked `auto_updates`
          # (e.g. cmux) which a plain `brew upgrade` would otherwise skip,
          # keeping self-updating apps on the deliberate "update" too.
          brew upgrade --greedy-auto-updates || true
          brew cleanup || true
        fi
        if command -v mas >/dev/null 2>&1; then
          echo "==> Upgrading Mac App Store apps"
          mas upgrade || true
        fi
      fi

      echo "==> Done. Enjoy your coffee."
    '';
  };
in
{
  environment.systemPackages = [ assemblingos-update ];
}
