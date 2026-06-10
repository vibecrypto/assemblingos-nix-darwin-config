# Install AssemblingOS On A Clean Mac

This is the quickest supported first-version installation.

## Expected Host

The prepared second-Mac profile is:

```text
AssemblingOS-MacBook-Pro
```

It currently assumes:

- Apple Silicon: `aarch64-darwin`
- macOS username: `drg`

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

## 4. Clone The Source Of Truth

```bash
cd ~
git clone git@github.com:vibecrypto/assemblingos-nix-darwin-config.git nix-darwin-config
cd ~/nix-darwin-config
```

## 5. Review The Host

```bash
rg -n 'AssemblingOS-MacBook-Pro|primaryUser|aarch64-darwin' flake.nix
```

Do not switch if the username or architecture is wrong.

## 6. Build

The helper validates and builds but does not apply:

```bash
bash scripts/bootstrap-darwin.sh AssemblingOS-MacBook-Pro
```

## 7. Apply

Only after the build succeeds:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch \
  --flake .#AssemblingOS-MacBook-Pro
```

After nix-darwin is installed, future changes use:

```bash
sudo darwin-rebuild switch --flake .#AssemblingOS-MacBook-Pro
```

## 8. Verify

Restart the terminal:

```bash
bash scripts/doctor.sh
which codex
which opencode
which gh
```

Open the declared GUI applications and approve macOS permissions only when the
application genuinely requires them.

## 9. Project Environment Test

```bash
mkdir -p ~/Projects/AssemblingCRM
cd ~/Projects/AssemblingCRM
nix flake init -t path:$HOME/nix-darwin-config#node
nix develop
node --version
```
