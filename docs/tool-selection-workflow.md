# AssemblingOS Tool Selection Workflow

Use this workflow when you need to do a task but do not know the best tool yet.

## Two Request Types

### Tool Intake

Use this when you already know the tool:

```text
Evaluate Raycast for AssemblingOS.
```

### Capability Discovery

Use this when you know the task but not the tool:

```text
I need to unzip/extract this ATEM software download. Find the best tool for AssemblingOS.
```

## Decision Criteria

Rank tools by:

1. Already installed or already declared in AssemblingOS.
2. Available in nixpkgs on both Darwin and Linux/NixOS.
3. Official upstream flake when the tool is not in nixpkgs.
4. Agent-first interface: CLI/API, non-interactive, predictable output, clear errors.
5. Fits the task directly without unnecessary complexity.
6. Has good documentation and active maintenance.
7. Can be tested before promotion.

## Install Targets

- Production Nix package: stable daily tool.
- Upstream flake/lab: official flake for tools not yet in nixpkgs.
- Homebrew cask: macOS GUI/vendor app.
- Manual install: proprietary vendor installer or hardware utility with no reliable Nix/Homebrew path.
- Lab flake: experimental tool or workflow-specific dependency.
- Reject/watchlist: redundant, fragile, unsafe, or not worth maintaining.

## Manual Install Assistance

When the best install path is manual, the agent should still help:

1. Find the official source.
2. Try direct download only when the site allows it.
3. If browser download is required, give exact user steps.
4. Inspect the downloaded artifact.
5. Identify whether it is an archive, app, dmg, pkg, script, driver, extension, or firmware utility.
6. Ask before privileged or system-changing actions.
7. Document persistent manual installs in `docs/manual-installs.md`.

## Example: ATEM Software Download

The official ATEM control software is a vendor install from Blackmagic Design. It should be documented as a manual hardware-vendor install.

For extracting the downloaded file:

- If it is `.zip`, use `unzip` or `the-unarchiver`/`unar`.
- If it is `.dmg`, mount it with macOS tools and run the vendor installer.
- If it is `.pkg`, treat it as a system installer and do not run it unattended unless you explicitly trust the source and understand the install scope.

The archive tool can be evaluated separately for production after repeated use.
