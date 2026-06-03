# Claude Code Setup Guide

This guide covers setting up Claude Code CLI and related AI tools.

## Prerequisites

1. **Claude Code CLI** - Install via:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **API Keys** - Required for various AI integrations

## Environment Variables

Add these to `~/.config/fish/local.fish` (not tracked in git):

```fish
# Claude API Key (required for Neovim plugins)
set -gx AI_CLAUDE_API_KEY "sk-ant-..."

# Vertex AI (optional - for Google Cloud integration)
set -gx CLAUDE_CODE_USE_VERTEX 1
set -gx CLOUD_ML_REGION us-east5
set -gx ANTHROPIC_VERTEX_PROJECT_ID your-project-id

# Other AI providers (optional)
set -gx AI_GROK_API_KEY "..."
set -gx AI_OPEN_AI_API_KEY "sk-..."
```

## Claude Code Configuration

### Settings Location

Claude Code stores settings in:
- Global: `~/.claude/settings.json`
- Project: `.claude/settings.json`

### Permissions Template

A permissions template is available at `packages/claude/settings.template.json`.

Copy and customize for your projects:

```bash
cp packages/claude/settings.template.json ~/.claude/settings.json
```

### Key Permissions

The template includes safe defaults for:
- Package managers (npm, pnpm, cargo, pip)
- Version control (git, gh, jj)
- Build tools (task, make, cmake, bazel)
- Common CLI utilities

## MCP Servers

MCP (Model Context Protocol) servers extend Claude's capabilities.

### Configuration

MCP servers are configured in `packages/mcp/servers.json`, which is symlinked to `~/.config/mcp/servers.json`.

### Included Servers

| Server | Description |
|--------|-------------|
| `fetch` | Web content fetching |
| `package-version` | Package version lookups |

### Adding New Servers

Edit `packages/mcp/servers.json`:

```json
{
  "mcpServers": {
    "your-server": {
      "command": "npx",
      "args": ["-y", "your-mcp-server"]
    }
  }
}
```

## Neovim Integration

Claude is integrated with Neovim through the `codecompanion.nvim` plugin.

### Configuration

See `packages/nvim/lua/plugins/` for AI-related plugins:
- `avante.lua` - Avante AI integration
- `completion.lua` - AI-powered completions

### Required Environment Variables

For Neovim AI features to work:
```fish
set -gx AI_CLAUDE_API_KEY "sk-ant-..."
```

## Troubleshooting

### Claude Code Not Finding API Key

1. Verify the environment variable is set:
   ```bash
   echo $AI_CLAUDE_API_KEY
   ```

2. If using Vertex AI, ensure you're authenticated:
   ```bash
   gcloud auth application-default login
   ```

### MCP Server Not Loading

1. Check the server is installed:
   ```bash
   npx -y mcp-server-fetch --help
   ```

2. Verify the config file exists:
   ```bash
   cat ~/.config/mcp/servers.json
   ```

### Neovim AI Features Not Working

1. Restart Neovim after setting environment variables
2. Check `:checkhealth` for AI-related issues
3. Verify API key is accessible in Neovim:
   ```vim
   :echo $AI_CLAUDE_API_KEY
   ```

## Security Notes

- **Never commit API keys** to version control
- Use `~/.config/fish/local.fish` for secrets (gitignored)
- Export secrets using `mise run secrets:export` for backup
- Rotate API keys periodically
