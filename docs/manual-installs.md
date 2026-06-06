# AssemblingOS Manual Installs

Manual installs are exceptions for software that is not practical to manage through Nix, Home Manager, nix-homebrew, or a project-local flake.

## When Manual Installs Are Acceptable

Use a manual install only when:

- the tool is not available in nixpkgs or Homebrew
- the official vendor installer is required
- the download is gated behind a browser, account, license, cookie, or registration flow
- the software installs drivers, system extensions, firmware utilities, or hardware support files
- packaging it would cost more than the value it provides

## Required Workflow

1. Prefer the official vendor website.
2. Avoid mirrors unless there is a documented reason.
3. Inspect the downloaded file before running it:
   - file type
   - size
   - archive contents
   - app bundle or package identity
   - checksum/signature when available
4. Ask before privileged installation.
5. Record the manual install here if it becomes part of the system.

## Approval Required

Always ask before:

- running `.pkg` installers
- running shell scripts from downloads
- installing drivers, launch agents, launch daemons, or system extensions
- granting permissions in System Settings
- updating device firmware
- moving apps into `/Applications`
- authorizing a cloud account or license

## Current Manual Installs

Add entries here using this format:

```text
Tool:
Purpose:
Official source:
Installer type:
Reason not managed by Nix/Homebrew:
Installed files or expected locations:
Last verified:
Notes:
```

## Example

```text
Tool: Blackmagic ATEM Switchers / ATEM Software Control
Purpose: Control and configure ATEM hardware switchers.
Official source: https://www.blackmagicdesign.com/support
Installer type: Vendor download, usually archive/dmg/pkg depending release.
Reason not managed by Nix/Homebrew: Official hardware vendor installer; not reliably available in nixpkgs/Homebrew.
Installed files or expected locations: Blackmagic apps/utilities under /Applications and support files under system locations.
Last verified:
Notes: Inspect downloaded artifact before install. Ask before running package installer or firmware utility.
```
