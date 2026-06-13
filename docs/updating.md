# Updating AssemblingOS

How package versions move forward, and how machines stay current — on both
Darwin and NixOS, without Homebrew.

## Mental model

The whole system (every package, both platforms) is pinned by one file:
`flake.lock`. "Updating" is two steps:

1. `nix flake update` — move the pin forward to newer nixpkgs.
2. `darwin-rebuild switch` / `nixos-rebuild switch` — rebuild to match.

Both are atomic and reversible (roll back to a previous generation). A machine
with a given `flake.lock` gets byte-identical versions — that reproducibility is
the point, and it is why apps stay in nixpkgs rather than Homebrew (brew is
macOS-only and unpinned).

## Two roles

- **Maintainer** runs `nix flake update`, tests, commits, and pushes. This is the
  only place new versions enter the product. Each commit is a release.
- **Fleet** (other machines, students, customers) does not run `flake update`.
  Each machine rebuilds from the published flake and converges on the
  maintainer's tested pin. Controlled and supportable.

## On-demand: `assemblingos-update`

The maintainer "bump + release" command (defined in
`modules/shared/update-command.nix`, on PATH on every host):

```bash
assemblingos-update
```

It runs: sync repo -> `nix flake update` -> build -> **only if the build passes**
switch the live system -> commit & push the new `flake.lock`. If the build fails
it stops before switching; revert with
`git -C ~/nix-darwin-config checkout flake.lock`.

Override the repo location with `ASSEMBLINGOS_REPO`.

There is also an agent skill (`assemblingos-update` in the agent-skills repo): say
"update" to Claude Code or Codex and it runs this command.

## Scheduled: `assemblingos.autoUpgrade`

Opt-in, **off by default**. Enable per host:

```nix
assemblingos.autoUpgrade.enable = true;
# assemblingos.autoUpgrade.flake = "github:vibecrypto/assemblingos-nix-darwin-config";
# assemblingos.autoUpgrade.dates = "weekly";   # NixOS calendar format
```

- **Darwin**: a `launchd` daemon rebuilds from the published flake weekly
  (`modules/darwin/auto-upgrade.nix`).
- **NixOS**: wires the native `system.autoUpgrade`
  (`modules/nixos/auto-upgrade.nix`).

This is the fleet/pull mechanism: it applies what the maintainer has released,
it does not itself run `flake update`.

## Fast-moving tools (AI agents)

`claude-code`, `codex`, etc. release faster than nixpkgs packages them, so even a
fresh `flake update` can trail upstream by days. Current policy: ride
nixpkgs-unstable. If the lag becomes a problem, pin the specific tool fresher via
an overlay or its upstream flake input in the shared flake (applies to both
platforms).
