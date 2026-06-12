# Install AssemblingOS On A Clean Mac

This is the quickest supported first-version installation.

Before starting, read:

```text
PROJECT_MEMORY.md
docs/pre-move-checklist.md
```

## Expected Host

The prepared second-Mac profile is:

```text
AssemblingOS-MacBook-Pro
```

It currently assumes:

- Apple Silicon: `aarch64-darwin`
- macOS username: `drg`
- macOS 14 or newer because the declared `cmux` cask requires it

If either value differs, edit the host definition in `flake.nix` before
switching.

## 1. Prepare macOS

Back up important data and install Apple Command Line Tools:

```bash
xcode-select --install
```

Check the machine:

```bash
whoami
uname -m
scutil --get LocalHostName
```

## 2. Install Nix

This repository expects Determinate Nix. Use its current official macOS
installer:

```text
https://docs.determinate.systems/determinate-nix/
```

Restart the terminal, then verify:

```bash
nix --version
nix store ping
```

## 3. Configure GitHub

Create a key on the new Mac:

```bash
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "assemblingos-new-mac" -f ~/.ssh/id_ed25519_github
```

Add the public key to GitHub:

```bash
cat ~/.ssh/id_ed25519_github.pub
```

Never share the private key without `.pub`.

Create `~/.ssh/config`:

```text
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
```

Test:

```bash
ssh -T git@github.com
```

Configure the author identity to use for future commits:

```bash
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR GITHUB EMAIL"
git config --global --get-regexp '^user\\.(name|email)$'
```

Do not guess these values. Use the identity you want attached to GitHub commits.

## 4. Clone The Source Of Truth

```bash
cd ~
git clone git@github.com:vibecrypto/assemblingos-nix-darwin-config.git nix-darwin-config
cd ~/nix-darwin-config
```

Do not use or copy the obsolete `~/.config/nix-darwin` checkout from the old
Mac.

## 5. Review The Host

```bash
whoami
uname -m
scutil --get LocalHostName
rg -n 'AssemblingOS-MacBook-Pro|primaryUser|aarch64-darwin' flake.nix
```

Do not switch if the username or architecture is wrong.

## 6. Build

The helper validates and builds but does not apply:

```bash
bash scripts/bootstrap-darwin.sh AssemblingOS-MacBook-Pro
```

It stops before building if the username, architecture, or minimum macOS
version does not match the prepared host.

## 7. Apply

Only after the build succeeds:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch \
  --flake .#AssemblingOS-MacBook-Pro
```

This first-switch bootstrap follows the current nix-darwin installation
workflow. The system configuration itself remains pinned by this repository's
`flake.lock`.

After nix-darwin is installed, future changes use:

```bash
sudo darwin-rebuild switch --flake .#AssemblingOS-MacBook-Pro
```

## 8. Verify

Restart the terminal:

```bash
bash scripts/doctor.sh
```

The doctor checks the Git state, required commands, declared agents, GUI
applications, and personal skill installation. Open the declared GUI
applications and approve macOS permissions only when the application genuinely
requires them.

Homebrew activation is deliberately conservative during migration. It will not
remove undeclared packages or automatically update/upgrade everything.

## 9. Install Personal Agent Skills

```bash
cd ~
git clone git@github.com:vibecrypto/assemblingos-agent-skills.git
cd ~/assemblingos-agent-skills
nix run .#install-agent-skills -- codex
nix run .#verify-agent-skills -- codex
```

Restart Codex after installation. System-provided Codex skills come with the
application; personal AssemblingOS, Skool, and communication skills come from
this private repository.

## 10. Creator Workstation

For the screen-only creator setup:

```bash
cd ~/nix-darwin-config
bash scripts/bootstrap-creator.sh
```

Read `docs/creator-workstation.md` before applying it. EVO and ATEM vendor
software still require documented manual installation and hardware binding.

## 11. Project Environment Test

```bash
mkdir -p ~/Projects/AssemblingCRM
cd ~/Projects/AssemblingCRM
nix flake init -t path:$HOME/nix-darwin-config#node
nix develop
node --version
```
