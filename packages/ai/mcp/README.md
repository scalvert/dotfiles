# MCP Catalog

`servers.json` is the canonical public-safe MCP catalog for portable stdio
servers.

## Rules

- Only include stdio MCP servers that can be shared across machines.
- Server names must be lowercase kebab-case.
- Each server must define:
  - `command`: executable name
  - `args`: array of string arguments
- Do not commit:
  - HTTP URLs
  - headers
  - environment variables
  - auth tokens
  - private company hostnames
  - project-specific server config

Private HTTP MCP servers and auth-bearing config belong in client-owned local
config or project-local files, not in this catalog.
