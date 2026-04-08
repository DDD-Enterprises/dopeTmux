# Tmux Host UI / UX / Mobile Design

## Status
Working design document for tmux-host operator UX, desktop cockpit UX, and mobile-compatible control surfaces.

---

## 1. Objective

Define a UI model for tmux-host that:
- preserves the tmux-first operator workflow
- stays external to Dopemux authority boundaries
- fits the dopemux operator visual language where Dopemux integration is present
- works cleanly on desktop and mobile without creating a second source of truth

---

## 2. Core Principle

The primary interface is **operational control**, not decoration.

The UI must answer, quickly:
- What is running?
- What is blocked?
- What needs action?
- Where do I jump next?
- What can I safely do from this device?

---

## 3. Surfaces To Design

- CLI output surface
- Desktop tmux cockpit surface
- Optional local dashboard / control surface
- Mobile control surface
- Notification and remote-action surface

---

## 4. Constraint

Mobile should be a **control and awareness** surface first.
It should not try to become a full tmux replacement.

---

## 5. Truth-Aligned UX Principles

### UX-01
The tmux host remains an **external host runtime**. Its UI must not imply that it owns Dopemux PM truth, memory truth, retrieval truth, or workflow authority.

### UX-02
The UI should present **control-plane state**, not invent a synthetic unified brain.

### UX-03
The primary reading mode is **operator status**:
- what is running
- what is degraded
- what is blocked
- what requires signoff
- what action is safe now

### UX-04
The primary interaction style should match the Dopemux operator model:
- procedural
- status-first
- compact
- explicit
- non-theatrical

### UX-05
Desktop may support deeper intervention.
Mobile should prioritize:
- visibility
- acknowledgement
- retry / resume
- bounded remote actions
- escalation to a real terminal when needed

---

## 6. What The Dopemux Examples Actually Teach

### 6.1 Operator language, not app theater
The brand system is explicit:
- write for operators, not spectators
- use command, status, result, next action
- design dashboards for operational reading, not brand theater
- use restrained color and compact typography
- prefer explicit states like `healthy`, `degraded`, `blocked`, `unknown`

Implication for tmux-host:
- no splashy home screen
- no decorative “workspace intelligence” nonsense
- no fake single health score
- every panel must map to a real runtime slice

### 6.2 Wizard pattern works when the task is risky and staged
The extraction wizard example is useful because it is:
- preview-first
- per-stage
- explicit about prerequisites
- confirmation-gated before expensive or risky execution
- educational only when useful, skippable when not

Implication for tmux-host:
Use a wizard only for:
- first-run setup
- profile creation
- secret/env migration
- daemon/bootstrap enablement
- mobile pairing / remote control setup

Do **not** build the primary cockpit as a wizard.
Daily operations need a stable control surface.

### 6.3 Flight deck pattern works for supervision, not for raw terminal replacement
The flight deck example shows a queue- and posture-driven supervisory dashboard with:
- one active focus target
- queue state
- posture / headline state
- recommended panel
- bounded actions
- visible blockers and validation status

Implication for tmux-host:
This is the right model for:
- desktop overview dashboard
- mobile remote control panel
- alert / posture framing

It is the wrong model for pretending you can fully operate tmux panes on a phone.

---

## 7. Proposed UX Architecture

The tmux-host UX should have **four layers**, not one giant dashboard.

### Layer A. CLI Control Surface
Primary authority for:
- deterministic commands
- scripting
- verification
- recovery
- exact failure messages

Key commands remain:
- `tmux-host up <profile>`
- `tmux-host ensure <profile>`
- `tmux-host status <profile>`
- `tmux-host respawn <profile> <pane-id>`
- `tmux-host reset-layout <profile>`
- `tmux-host doctor`

This stays the canonical operator surface.

### Layer B. tmux-native cockpit
Inside tmux itself, the core UX should be:
- stable pane labels
- deterministic window structure
- compact status line or header
- role-based jump/focus helpers
- clear degraded markers

This is where real work happens.

### Layer C. Local dashboard / flight deck
Optional, secondary, read-mostly operator surface for:
- profile/session overview
- pane health
- adapter state
- last error
- recommended next action
- signoff-required states

This is not the truth source. It is a **derived operator view**.

### Layer D. Mobile remote surface
Read-first and action-bounded.
Used for:
- awareness
- acknowledging degraded state
- retrying safe actions
- resuming/attaching later from a terminal app
- opening escalation links or copying commands

---

## 8. Desktop UX Model

## 8.1 Core desktop views

### View 1: Session index
Purpose:
- show all profiles and whether each session is `ready`, `degraded`, `missing`, or `unknown`

Rows should include:
- profile id
- session name
- state
- attached yes/no
- panes materialized vs declared
- top blocker or last error
- safe next action

### View 2: Active profile cockpit
Purpose:
- show one profile in detail

Panels:
1. **Header**
   - profile name
   - session state
   - attach state
   - last verification time
   - default safe action
2. **Pane grid / list**
   - pane id
   - title
   - adapter
   - cwd
   - health/status
   - last error
   - respawn allowed yes/no
3. **Action rail**
   - attach
   - ensure
   - respawn pane
   - reset layout
   - doctor
4. **Recent events**
   - started
   - failed
   - respawned
   - layout reset
   - env validation blocked

### View 3: Setup / migration wizard
Purpose:
- first-run only
- profile authoring
- env file creation
- shell boundary migration
- SSH bootstrap enablement

This should not be the daily home screen.

---

## 8.2 Desktop information hierarchy

Priority order:
1. current state
2. blocker / degradation reason
3. next safe action
4. secondary detail
5. history/logs

If the interface makes logs louder than the actual state, it is badly designed.

---

## 8.3 Desktop interaction rules

- Every action button must map to a real CLI command.
- No action should silently run a compound workflow without making it explicit.
- Dangerous operations should require confirmation when they destroy or recreate.
- Use stable wording:
  - `Ensure`
  - `Attach`
  - `Respawn`
  - `Reset Layout`
  - `Doctor`
  - `Down`
- Avoid vague labels like:
  - `Fix`
  - `Heal`
  - `Boost`
  - `Optimize`

Humans adore vague buttons until they nuke a session.

---

## 9. tmux-native UX Model

The tmux-native UX matters more than any external dashboard.

## 9.1 Required tmux-native affordances

- pane titles always visible or cheaply discoverable
- a compact session header with:
  - profile
  - state
  - active pane role
  - degraded indicator
- deterministic key bindings for:
  - next pane
  - previous pane
  - focus pane by id/role
  - respawn active pane
  - reset layout
  - open status/help overlay

## 9.2 Statusline shape

Minimal fields:
- profile id
- session state
- pane id / role
- degraded count
- clock only if it earns its pixels

Do not turn the tmux statusline into Times Square.

## 9.3 Error presentation in tmux

When a pane fails, do not leave silent dead air.
The pane should show a compact failure card such as:
- `Failed: adapter gemini missing binary: gemini`
- `Next: install gemini or update PATH`
- `Action: tmux-host respawn dopemux-dev right`

This is more useful than a blank pane and less annoying than a fake dashboard overlay.

---

## 10. Mobile UX Model

## 10.1 Mobile purpose

Mobile is for:
- seeing whether a session is healthy
- spotting what broke
- performing safe bounded actions
- reading what to do next
- deciding whether to open a real terminal

Mobile is **not** for:
- freeform pane editing
- dense multi-pane terminal control
- deep configuration authoring
- pretending touch screens are ideal for tmux orchestration

## 10.2 Mobile surface options

### Option A. Mobile web control panel
Best default.

Pros:
- no platform lock-in
- can be read from iPhone/Android/browser
- easy to keep read-mostly
- can deep-link to terminal commands or remote terminal apps

Cons:
- must be carefully scoped to avoid becoming a fake source of truth

### Option B. Telegram-style operator interface
Potentially strong if you want notifications + quick actions.

Pros:
- excellent for alerting, approve/retry/resume actions
- aligns with Dopemux operator workflow ideas
- good for low-friction remote acknowledgement

Cons:
- weak for dense state exploration
- bad for configuration-heavy flows

### Option C. Native app
Not justified for v1.

Pros:
- deeper device integration

Cons:
- too much product theater for a host runtime
- duplicates effort
- higher maintenance cost

### Recommendation
Ship:
1. mobile web control surface
2. optional notification/chat integration later
3. no native app in v1

---

## 10.3 Mobile information hierarchy

Single-screen top section should show:
- profile
- session state
- attached yes/no
- panes healthy vs total
- one primary blocker
- one recommended next action

Then expandable sections:
- panes
- recent events
- actions
- runbook / commands

## 10.4 Mobile action model

Allowed v1 mobile actions:
- `Ensure`
- `Attach Info` or `Open Terminal`
- `Respawn Pane`
- `Reset Layout`
- `Doctor`
- `Down` only if explicitly confirmed and clearly destructive

Each action must:
- map to one real host command
- show result text
- show exact failure if it fails
- avoid compound hidden workflows

## 10.5 Mobile-friendly fallback pattern

For actions too risky or too awkward on mobile:
- show the exact command
- provide copy action
- provide “open in terminal” deep link if environment supports it

Example:
- `Next: run 'tmux-host respawn dopemux-dev right' from a terminal.`

This is elegant because it respects reality instead of roleplaying a touchscreen DevOps empire.

---

## 11. Cross-Device Design Rules

### Rule 1
Desktop and mobile must show the **same underlying states**:
- `ready`
- `degraded`
- `missing`
- `unknown`
- `attached`

### Rule 2
Desktop may expose more detail, but not different truth.

### Rule 3
If a mobile action exists, its desktop equivalent must be obvious.

### Rule 4
Never invent a second state machine just for the dashboard.
The dashboard is derived from host + tmux inspection.

### Rule 5
Do not show fake aggregate confidence scores.
Show real blockers, real pane failures, real next actions.

---

## 12. Proposed v1 UI Surface Set

### v1 required
- polished CLI output
- tmux-native status/header affordances
- optional local dashboard web UI for desktop
- mobile-responsive version of the same dashboard

### v1 optional
- first-run setup wizard
- SSH/mobile pairing flow

### v1 deferred
- native mobile app
- drag-and-drop pane layout editor
- visual workflow builder
- freeform profile editor on mobile
- real-time animated telemetry wall

---

## 13. Best Initial Screen Designs

## 13.1 Desktop home screen
A compact session table.

Columns:
- Profile
- State
- Session
- Panes
- Attached
- Blocker
- Next

## 13.2 Desktop profile screen
Top summary bar + pane list + action rail + recent events.

## 13.3 Mobile home screen
Per profile cards:
- name
- state chip
- panes `3/4`
- blocker line
- one primary action button

## 13.4 Mobile profile screen
Sections:
- summary
- pane list
- actions
- recent events
- exact commands

---

## 14. UX Risks To Avoid

- turning a tmux host into a fake all-knowing platform dashboard
- hiding real errors behind “smart” summaries
- using color or icons without explicit text state
- making mobile a second control plane
- building setup wizard flows into daily operations
- introducing decorative naming instead of procedural commands
- letting the dashboard imply ownership of Dopemux internals it does not own

---

## 15. Final Recommendation

The right UX is:
- **CLI as canonical control surface**
- **tmux as primary work surface**
- **dashboard as derived supervisory surface**
- **mobile as awareness + bounded control surface**

In one sentence:

> Build tmux-host like a control console with a matching pocket remote, not like a mini operating system trying to cosplay as mission control.

---

## 16. Next Design Step

Translate this into:
- component map for the dashboard/web UI
- state model shared by desktop and mobile
- action matrix by surface
- v1/v2 cut line
- then generate the UX/UI-focused task packet series before Series B implementation starts
