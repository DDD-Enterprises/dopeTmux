# dopeTmux

Repository for the tmux-host / dopeTask bootstrap materials, operator prompts, and UI/state design notes.

## Current layout

- `AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `PROJECT_INSTRUCTIONS.md`: repository instruction surfaces
- `BUNDLES/`: dopeTask bundle packets and bundle-local validation files
- `ops/`: operator profile, exported prompt, and templates
- `out/`: deterministic reports and packet artifacts
- `tmux_host_ui_state_and_actions.md` and `tmux_host_ui_ux_mobile_design.md`: shared tmux-host design notes

## Repository hygiene

- Root ignore rules keep local environments, caches, logs, and secrets out of version control.
- Pre-commit hooks enforce baseline file hygiene on commits.
- Source code, when introduced, should follow the source-first layout described in the task packets.
