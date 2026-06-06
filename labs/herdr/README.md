# Herdr Lab

This lab evaluates Herdr without installing it globally or promoting it to the production Darwin system.

## Why A Lab

Herdr is an agent multiplexer. It overlaps with `cmux` and terminal/session workflows, so it should be tested before promotion.

The official project provides a Nix flake, so AssemblingOS prefers this lab over Homebrew for evaluation.

## Commands

Enter the lab:

```bash
cd labs/herdr
nix develop
```

Inside the shell:

```bash
herdr --help
```

Leave the shell:

```bash
exit
```

## Mental Model

- `nix run github:ogulcancelik/herdr/v0.6.8`: run Herdr once from any folder.
- `nix develop`: enter this lab shell and make Herdr available on `PATH` only inside the shell.
- production flake: promote later only if Herdr becomes a daily tool.

## Promotion Criteria

Promote Herdr only if it improves daily agent workflows compared with `cmux`, terminal tabs, or direct agent CLIs.
