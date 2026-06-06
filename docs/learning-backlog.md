# Learning Backlog

These topics are worth learning because they are reusable across AssemblingOS and other local AI projects.

## ChromaDB

Learn what ChromaDB provides as a local vector database:

- collections
- embeddings
- metadata filters
- persistence
- HTTP client/server mode
- when to use ChromaDB instead of SQLite
- operational risks: data growth, backups, migration, and privacy

## RAG

Learn retrieval-augmented generation as a general pattern:

- chunking documents
- embedding chunks
- storing vectors
- semantic search
- reranking
- context injection into LLM prompts
- evaluation: citation quality, hallucination reduction, and stale data

## AssemblingOS Questions

- Should AssemblingOS provide a standard local vector service template?
- Should labs share one ChromaDB service, or should each lab own its own isolated ChromaDB data?
- What should be the default backup/export strategy for local AI memory?
- Which tools should be allowed to write to shared memory, and which should stay project-local?
