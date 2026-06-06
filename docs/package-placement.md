# AssemblingOS Package Placement

Use the smallest stable layer that matches the tool.

## Agent-First Rule

AssemblingOS should prefer tools that agents can operate reliably:

- stable CLI or local API
- non-interactive mode
- predictable stdout/stderr
- clear exit codes
- machine-readable output when useful
- good documentation
- cross-platform Nix availability when quality is comparable

GUI tools are fine when they are the correct user-facing interface, but they should not be the only path for workflows that need automation.

## Use Nix System Packages

Use `environment.systemPackages` for stable tools you want available system-wide on this Darwin host:

- editors
- CLI tools
- developer language servers
- daily AI agents
- GUI apps that work well from nixpkgs

## Use Homebrew

Use `homebrew.brews` and `homebrew.casks` for:

- proprietary macOS GUI apps
- apps with better Homebrew support than nixpkgs support
- audio/video apps or drivers that integrate deeply with macOS
- Mac App Store helpers such as `mas`

## Use Home Manager Later

Use Home Manager for user-specific behavior:

- shell config
- editor config
- Git config
- aliases
- per-user CLI preferences

Home Manager is the recommended next layer, but it is intentionally not enabled in this first Darwin organization step.

## Use Project-Local Flakes

Use project-local `flake.nix` devShells for labs:

- experimental AI tools
- Python/Node projects with unstable dependencies
- voice/video AI experiments
- tools being evaluated before promotion

## Use Docker Carefully

Docker can be useful for side services and complex app stacks. Avoid it as the default for real-time macOS audio/video, virtual devices, or Apple Silicon GPU workflows because Docker Desktop on macOS runs inside a Linux VM.

## Use Manual Installs As Exceptions

Manual installs are acceptable for vendor software, drivers, system extensions, firmware utilities, and gated downloads that cannot be managed cleanly through Nix or Homebrew.

Manual installs must be documented in `docs/manual-installs.md` if they become part of the system.

## Example: Archive Extraction

When the task is "extract this downloaded vendor software", choose the tool by file type and automation needs:

- `.zip`: prefer `unzip` for simple ZIP files.
- mixed archive formats: prefer `the-unarchiver`/`unar` if available.
- `.7z`: prefer `p7zip`.
- `.tar.*`: prefer `bsdtar`/`tar`.
- `.dmg` or `.pkg`: this is macOS installer territory; use macOS-native tooling and document the manual/vendor install.

Do not add an archive tool to production just because it was useful once. Promote it when it becomes part of a repeated workflow.
