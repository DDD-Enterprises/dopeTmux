# AGENTS Instructions

<!-- DOPETASK:BEGIN -->
<!-- directive-pack:dopetask@v1 -->
## dopeTask Directives (Base)

1. Task packets are law.
2. Perform only actions explicitly authorized by the active task packet.
3. Scope is strict: no drive-by refactors, no opportunistic cleanup, no hidden extra work.
4. Treat allowlists, file scopes, and verification gates as hard requirements.
5. Use evidence-first reasoning for every claim.
6. Never fabricate command runs, outputs, file states, tests, or approvals.
7. If evidence is missing, mark the claim `UNKNOWN` and define a deterministic check.
8. Verification is mandatory for completion.
9. Record verification with the exact commands run and raw outputs.
10. Do not summarize away failing output; include failure details and exit codes.
11. Deterministic operation is required:
12. Do not claim a command was run unless its output is present in logs.
13. Do not claim a file changed unless the diff reflects it.
14. Use minimal diffs and localized edits.
15. Keep behavior stable unless the packet explicitly authorizes a behavior change.
16. Keep assumptions explicit and testable.
17. Do not invent requirements, contracts, schemas, or policy text.
18. Respect stop conditions exactly as written in the packet.
19. Escalate immediately when blocked by missing artifacts, permissions, or contradictory instructions.
20. Escalation must include:
21. What is blocked.
22. Why it is blocked.
23. The smallest packet change needed to proceed.
24. Completion requires an Implementer Report with:
25. Summary of changes.
26. Files changed and added.
27. Verification commands and raw outputs.
28. Deviations from packet instructions (if any).
29. Explicit stop-condition confirmation.
30. If any required gate was not run, report incomplete and stop.
<!-- DOPETASK:END -->
<!-- CHATX:BEGIN -->
(disabled)
<!-- CHATX:END -->

Agent-specific rules are inserted in sentinel blocks only.

---

## Claude-Code Doctrine Alignment

This file is the Codex-facing authority. The Claude-Code-facing companion is `CLAUDE.md`, which embeds a brief governance section and links to the full canonical module at `.claude/governance-principles.md`.

The canonical module elaborates the same Truth Order and proof-and-finality regime for Claude-Code sessions, plus inspect-before-edit, minimal correct change, deterministic-systems-first, validation policy with explicit `PASS / FAIL / NOT_RUN` buckets, confidence states, and the required final response structure.

If this file defines PAL workflow chains, the module references them rather than duplicating. Otherwise the module's defaults apply (`analyze → planner → codereview → precommit` for minimum work; risky/architecture variant adds challenge gates).

When updating doctrine, keep these three files in sync:

- `AGENTS.md` (this file) — Codex authority, lifecycle, chains (if defined), proof bundle
- `CLAUDE.md` — Claude-Code-facing summary + non-negotiables checklist
- `.claude/governance-principles.md` — full canonical doctrine, referenced by both
