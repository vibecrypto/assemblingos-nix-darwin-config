# Pre-Move Checklist

Use this before retiring the current Mac or relying on the second Mac as the
primary AssemblingOS machine.

## Authoritative Repositories

System:

```text
git@github.com:vibecrypto/assemblingos-nix-darwin-config.git
~/nix-darwin-config
```

Personal agent skills:

```text
git@github.com:vibecrypto/assemblingos-agent-skills.git
~/assemblingos-agent-skills
```

The old `~/.config/nix-darwin` checkout is obsolete, dirty, and not connected
to the current migration remote. Do not copy, merge, build, or switch from it.

### Legacy configuration review

The obsolete checkout contained these items that were intentionally not copied
into the production repo:

- Firefox
- IINA
- The Unarchiver
- Slack
- Zoom
- Starship
- Bat
- Pwnvim
- custom Emacs packages and configuration

Chrome and OBS are already represented in the current repo. The remaining
legacy items should be evaluated and added deliberately after the new Mac is
stable. The old checkout also used outdated inputs and destructive Homebrew
cleanup, so it must not be revived as a whole.

## Verify Git Before Leaving

Run in both authoritative repositories:

```bash
git fetch --prune origin
git status --short --branch
git branch -vv
git log -1 --oneline --decorate
```

Required result:

- branch is `main`
- branch matches `origin/main`
- worktree is clean

## Data Git Does Not Preserve

Decide whether to back up each item before retiring the old Mac.

### Personal content

`~/Documents/Content creator` is not part of the AssemblingOS Git repository.
Copy it to an encrypted external disk or a private repository. The current
Codex shell cannot enumerate that folder because macOS privacy controls deny
broad access, so this must be verified manually.

### Odysseus

Portable code and startup instructions are in Git. Runtime data is not.

The ignored Odysseus app checkout was verified clean on its upstream `dev`
branch, so the application code can be cloned again instead of copied.

Back up these only if the research/history matters:

```text
~/nix-darwin-config/labs/odysseus/app/data/
~/nix-darwin-config/labs/odysseus/services/chroma/data/
```

Do not back up:

```text
labs/odysseus/app/.venv/
labs/odysseus/services/chroma/uv-cache/
```

Those environments and caches should be reconstructed.

Odysseus data contains authentication state and private research. Use encrypted
storage and do not commit it.

### Local models

The current Hugging Face cache contains a roughly 16 GB Gemma GGUF download.
Choose one:

- redownload it on the new Mac from the recorded model ID
- copy the cache using an external disk

Model currently detected:

```text
unsloth/gemma-4-26B-A4B-it-GGUF
```

The Qwen model directory currently appears to be an incomplete or metadata-only
download:

```text
unsloth/Qwen3.6-35B-A3B-GGUF
```

### Codex

Personal skills are restored from `assemblingos-agent-skills`.

Optional history:

```text
~/.codex/sessions/
~/.codex/memories/
```

Do not copy or commit:

```text
~/.codex/auth.json
```

Sign in again on the new Mac. Treat any copied Codex configuration or history
as private data and use encrypted storage.

### SSH and credentials

Prefer creating a new SSH key on the new Mac and adding its public key to
GitHub. Never place private keys, API tokens, browser profiles, Keychain data,
or `.env` files in either repository.

### Creator setup

The repository preserves the portable OBS and EVO baseline. macOS permissions,
screen selection, voice-processing routing, vendor registrations, and
machine-specific device identifiers must be configured again.

If exact OBS scenes matter, export them separately and review the export for
stream credentials and machine-specific identifiers before transfer.

## New-Mac Identity Check

Run on the new Mac:

```bash
whoami
uname -m
sw_vers
scutil --get LocalHostName
```

Prepared defaults:

```text
username: drg
architecture: aarch64-darwin
host profile: AssemblingOS
minimum macOS: 14
```

Do not switch until these values are compatible with `flake.nix`.

## Recommended Order On The New Mac

1. Install Apple Command Line Tools.
2. Install Determinate Nix.
3. Create a new GitHub SSH key and verify access.
4. Clone `nix-darwin-config`.
5. Give the new agent the New Mac Installation prompt from
   `docs/agent-handoff-prompts.md`.
6. Build `AssemblingOS`.
7. Review the build and ask separately before the first switch.
8. Run `scripts/doctor.sh`.
9. Clone `assemblingos-agent-skills`.
10. Install and verify the personal skills.
11. Restore only the local data selected above.
12. Configure creator hardware and macOS permissions.

## Ready To Retire The Old Mac When

- both authoritative repositories are clean and synchronized
- the new Mac builds and switches successfully
- `scripts/doctor.sh` reports no failures on the new Mac and all warnings have
  been reviewed
- all three personal Codex skills are installed
- important personal content has an independent backup
- a decision was made for Odysseus data and local models
- GitHub access works from the new Mac
- the intended Git author name and email are configured
- essential creator routing has been tested

Do not erase or retire the old Mac until the new Mac has passed this checklist.
