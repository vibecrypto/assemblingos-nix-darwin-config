# AssemblingOS Package Placement

Use the smallest stable layer that matches the tool.

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
