# Agents

Agent definitions should be explicit, narrow, and owned by this package only when they are broadly useful.

Prefer fewer agents:

- reviewer: independent review and risk finding
- researcher: documentation and source discovery
- executor: implementation in a known repo
- verifier: test and validation pass

Avoid always-on orchestration layers unless the task requires them. Client-specific agent wiring should be generated from shared definitions where possible.
