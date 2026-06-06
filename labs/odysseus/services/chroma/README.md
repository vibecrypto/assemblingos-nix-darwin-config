# ChromaDB Service

ChromaDB is the local vector database used by Odysseus for memory, RAG, document search, and tool indexing.

This service is intentionally separate from the Odysseus Python `.venv`. Odysseus uses the lightweight `chromadb-client` package, and the upstream README warns not to mix it with the full embedded `chromadb` package in the same environment.

## Start

From the lab:

```bash
cd /Users/drg/nix-darwin-config/labs/odysseus
nix develop
bash scripts/start-chromadb.sh
```

This starts ChromaDB on:

```text
127.0.0.1:8100
```

Keep this terminal running while Odysseus is running. Use a second terminal for Odysseus itself.

## Data

Runtime data is stored in:

```text
services/chroma/data
```

The Python package cache is stored in:

```text
services/chroma/uv-cache
```

Both are ignored by Git.

## Why uv

Nix provides `uv` reproducibly through the lab shell. `uvx` then runs the Python ChromaDB server in an isolated tool environment without installing it globally and without adding it to Odysseus' `.venv`.
