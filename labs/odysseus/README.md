# Odysseus Lab

This lab evaluates Odysseus without adding it to the production Darwin system.

## Why A Lab

Odysseus is a high-level self-hosted AI workspace. It overlaps with chat apps, coding agents, memory/skills, local model runtimes, research tools, documents, calendar/tasks, and web UI workflows.

The upstream project recommends Docker generally, but documents native macOS for Apple Silicon because Docker Desktop on macOS cannot use the Metal GPU. For AssemblingOS, use this lab to evaluate the native path first.

## Enter The Lab

```bash
cd /Users/drg/nix-darwin-config/labs/odysseus
nix develop
```

The lab provides:

- Python 3.12
- uv
- git
- tmux
- sqlite
- ffmpeg

## ChromaDB Memory Service

Odysseus can start without ChromaDB, but memory, RAG, document search, and tool indexing are degraded until a ChromaDB service is reachable.

Start ChromaDB in a separate terminal:

```bash
cd /Users/drg/nix-darwin-config/labs/odysseus
nix develop
bash scripts/start-chromadb.sh
```

Then start or restart Odysseus in another terminal. The default Odysseus settings already look for ChromaDB at:

```text
localhost:8100
```

Do not install the full `chromadb` package inside Odysseus' `.venv`; keep it as a separate service.

## First Native Test

Clone Odysseus into a local app folder:

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git app
cd app
```

Create a project-local Python environment:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```

Prepare local config:

```bash
cp .env.example .env
```

Keep the first run loopback-only:

```bash
APP_BIND=127.0.0.1 APP_PORT=7860 python setup.py
APP_BIND=127.0.0.1 APP_PORT=7860 python -m uvicorn app:app --host 127.0.0.1 --port 7860
```

Open:

```text
http://127.0.0.1:7860
```

## Boundaries

- Do not expose Odysseus to LAN or public internet during the first test.
- Do not commit `.env`, `.venv`, `app/data`, or secrets.
- Do not promote to production until it proves useful against Codex, OpenCode, Claude Code, Herdr, Ollama, and LM Studio workflows.

## Promotion Criteria

Promote only if Odysseus becomes a daily AI workspace and the native Apple Silicon path is reliable.
