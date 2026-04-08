# Tmux Host UI State And Actions

## Status

Working canvas for tmux-host UI state, surface behavior, and cross-device interaction rules.

---

## 1. Scope

This canvas covers:

- shared UI state model
- action matrix by surface
- desktop vs mobile behavior boundaries
- operator-safe interaction rules

It does not redefine host architecture, tmux lifecycle, or system authority boundaries.

---

## 2. Shared UI State Model

This state model must be shared across:

- CLI
- tmux-native status/header
- desktop dashboard
- mobile dashboard
- notifications / remote actions

No surface gets its own invented truth model.

### 2.1 Canonical profile states

#### `ready`

Meaning:

- declared session exists
- declared panes are materialized
- required metadata is present
- no material validation failures are active

Display:

- green state chip
- exact pane ratio visible
- no warning framing

#### `degraded`

Meaning:

- session exists
- one or more panes failed, are missing, lost metadata, or failed runtime validation

Display:

- amber state chip
- blocker elevated above logs/history
- one primary recovery action

#### `missing`

Meaning:

- no session exists for the profile

Display:

- gray state chip
- primary action = `Ensure`

#### `unknown`

Meaning:

- host cannot prove current session state safely

Display:

- warning chip
- explicit reason if known
- primary action = `Doctor`

### 2.2 Overlay states

#### `attached`

Secondary badge only. Not a replacement for health state.

#### `blocked`

Action-state overlay used when an operation cannot proceed because of a gate such as:

- missing env
- missing binary
- invalid profile
- destructive action lacking confirmation

### 2.3 Pane states

Each pane should have its own derived state:

- `running`
- `failed`
- `missing`
- `unknown`
- `starting`

### 2.4 Action result states

Every action returns one of:

- `completed`
- `failed`
- `blocked`
- `queued` only if truly queued by runtime

### 2.5 Event severities

Use:

- `info`
- `warning`
- `error`
- `success`

### 2.6 Neon visual system

#### Base visual posture

- dark matte background
- bold headers
- crisp dividers
- restrained glow
- no glassmorphism
- no soft gradient wash

#### Accent palette

- electric cyan = primary interaction
- violet = secondary structure
- magenta = active focus / selected panel
- green = healthy / completed
- amber = degraded / attention needed
- red = failed / blocked / destructive
- gray = missing / inactive / unknown fallback

#### Usage rules

- neon on borders, chips, focus rings, active tabs, and key metrics
- status colors outrank decorative accents
- keep cards mostly dark and readable
- no full-screen neon flood

### 2.7 Shared state object

```json
{
  "profile_id": "dopemux-dev",
  "session_name": "host-dopemux-dev",
  "state": "degraded",
  "attached": true,
  "blocked": false,
  "declared_panes": 4,
  "materialized_panes": 3,
  "degraded_pane_ids": ["right"],
  "primary_blocker": "adapter claude missing binary",
  "recommended_action": {
    "label": "Respawn Pane",
    "command": "tmux-host respawn dopemux-dev right"
  },
  "last_verification_ts": "2026-04-08T22:10:00Z"
}
```

---

## 3. Action Matrix By Surface

### 3.1 Rule

Every visible action must map to one real host command or one explicit navigation handoff. No fake action labels. No silent compound workflows.

### 3.2 Surface capabilities

| Action                   | CLI | tmux-native     | Desktop dashboard | Mobile dashboard          |
| ------------------------ | --- | --------------- | ----------------- | ------------------------- |
| View profile status      | Yes | Yes             | Yes               | Yes                       |
| View pane state          | Yes | Yes             | Yes               | Yes                       |
| Ensure profile           | Yes | Yes             | Yes               | Yes                       |
| Attach session           | Yes | Yes             | Yes               | Info / open terminal only |
| Focus pane               | Yes | Yes             | Yes               | No                        |
| Respawn pane             | Yes | Yes             | Yes               | Yes                       |
| Reset layout             | Yes | Yes             | Yes               | Yes                       |
| Run doctor               | Yes | Limited trigger | Yes               | Yes                       |
| Destroy session (`Down`) | Yes | Limited         | Yes with confirm  | Yes with hard confirm     |
| Edit profile config      | Yes | No              | Desktop only      | No                        |
| Create profile           | Yes | No              | Desktop wizard    | No                        |
| Shell/env migration      | Yes | No              | Desktop wizard    | No                        |
| Live multi-pane work     | Yes | Yes             | No                | No                        |

### 3.3 CLI actions

Canonical actions:

- `tmux-host ensure <profile>`
- `tmux-host up <profile>`
- `tmux-host attach <profile>`
- `tmux-host status <profile>`
- `tmux-host respawn <profile> <pane-id>`
- `tmux-host reset-layout <profile>`
- `tmux-host doctor`
- `tmux-host down <profile>`

### 3.4 tmux-native actions

Allowed:

- focus next/previous pane
- focus pane by id/role
- respawn active pane
- reset layout
- open help/status overlay
- trigger ensure/doctor through bound helpers if useful

Not appropriate:

- full profile editing
- env-file authoring
- wizard-driven setup

### 3.5 Desktop dashboard actions

Allowed:

- Ensure
- Attach
- Respawn Pane
- Reset Layout
- Doctor
- Down with confirmation
- Open config / wizard flows
- Open logs / recent events / exact commands

Desktop-only setup flows:

- create profile
- edit profile
- env file setup
- shell boundary migration
- SSH/mobile pairing

### 3.6 Mobile dashboard actions

Allowed in v1:

- Ensure
- Respawn Pane
- Reset Layout
- Doctor
- Down with strong confirmation
- Copy exact command
- Open terminal / attach info handoff

Not allowed in v1:

- freeform pane control
- profile editing
- env authoring
- layout editing
- multi-pane active work

### 3.7 Confirmation rules

Require confirmation for:

- `Down`
- any action that recreates multiple panes
- any action that overwrites layout state

Do not require confirmation for:

- status refresh
- doctor
- single-pane respawn
- ensure when session is missing

### 3.8 Fallback handoff pattern

When a surface cannot safely perform an action, show:

- exact command
- copy action
- open terminal handoff if available

Example:

- `Next: run 'tmux-host attach dopemux-dev' from a terminal.`

---

## 4. Desktop vs Mobile Component Map

## 4.1 Goal

Define one shared operator UI system with two render modes:

- desktop supervisory cockpit
- mobile remote control panel

Same truth model. Different density and action depth.

---

## 4.2 Shared component inventory

These are the core components available to the system:

- App shell
- Global status bar
- Profile session table
- Profile summary header
- State chip
- Pane list / pane cards
- Action rail
- Primary blocker panel
- Recommended next action panel
- Recent events feed
- Exact command panel
- Attach handoff panel
- Setup / migration wizard
- Confirmation modal
- Toast / action result banner

Not every component belongs on every surface.

---

## 4.3 Desktop component map

### Desktop home: Session Index

#### Components present

1. **App shell**

   - top nav or left rail
   - compact and structural
   - no marketing chrome

2. **Global status bar**

   - overall host runtime availability
   - config root status
   - last refresh / last verification

3. **Profile session table** Columns:

   - Profile
   - State
   - Session
   - Panes
   - Attached
   - Blocker
   - Next

4. **State chip** in each row

   - bright, high-contrast, neon-edged
   - text always explicit

5. **Recommended next action button** in each row

   - one primary action only

#### Components intentionally absent

- pane detail grid
- recent full event feed
- setup wizard content

Desktop home should answer: what needs attention first?

---

### Desktop detail: Active Profile Cockpit

#### Components present

1. **Profile summary header** Fields:

   - profile name
   - session name
   - state chip
   - attached badge
   - pane ratio
   - last verification timestamp

2. **Primary blocker panel**

   - placed high on screen
   - visible only when degraded / blocked / unknown
   - contains exact reason and next safe action

3. **Recommended next action panel**

   - one dominant CTA
   - optional secondary actions beneath

4. **Pane list** Each row/card contains:

   - pane id
   - title
   - role
   - adapter
   - cwd
   - pane state chip
   - last error
   - respawn allowed

5. **Action rail**

   - Ensure
   - Attach
   - Respawn Pane
   - Reset Layout
   - Doctor
   - Down

6. **Recent events feed**

   - reverse chronological
   - compact
   - severity coded
   - ideally collapsible

7. **Exact command panel**

   - shows the real CLI equivalent for the primary action
   - copyable

#### Optional desktop-only component

8. **Attach handoff panel**
   - shows exact attach command
   - useful when dashboard is supervisory only

---

### Desktop setup flows

#### Setup / migration wizard

Desktop only. Used for:

- create profile
- edit profile
- env file setup
- shell boundary migration
- SSH/mobile pairing
- daemon/bootstrap enablement

#### Reason

These are configuration-heavy, risky, and multi-step. They do not belong on mobile unless you enjoy typo-driven suffering.

---

## 4.4 Mobile component map

## Mobile home: Profile Cards

#### Components present

1. **App shell**

   - minimal top bar only
   - no left rail
   - no persistent dense navigation

2. **Global status strip**

   - optional thin top strip
   - use only if it earns space

3. **Profile cards** Each card contains:

   - profile name
   - state chip
   - pane ratio
   - attached badge if relevant
   - one blocker line
   - one primary action button

4. **Recommended next action button**

   - single dominant button per card
   - no action clusters on list screen

#### Components intentionally absent

- dense tables
- multi-column layouts
- full pane metadata
- long event history

Mobile home should answer: what is broken, and what is the one safe thing I can do now?

---

## Mobile detail: Profile Remote Panel

#### Components present

1. **Profile summary block**

   - profile name
   - session name
   - state chip
   - pane ratio
   - attached badge
   - primary blocker

2. **Primary blocker panel**

   - immediately below summary
   - exact reason
   - no vague summaries

3. **Primary action block**

   - one dominant CTA
   - optional two or three secondary safe actions max

4. **Pane cards** Each pane card contains:

   - pane id / title
   - adapter
   - pane state chip
   - last error if relevant
   - respawn button if safe

5. **Exact command panel**

   - copy command
   - open terminal handoff if supported

6. **Recent events section**

   - collapsed by default
   - latest 3 to 5 items only

#### Components intentionally absent

- inline profile editing
- cwd-heavy dense lists by default
- broad action rail with many buttons
- configuration forms

---

## 4.5 Responsive behavior rules

### Rule 1

Desktop table becomes mobile card list. No horizontal-scroll clownery.

### Rule 2

Desktop pane list becomes stacked pane cards on mobile.

### Rule 3

Desktop action rail becomes:

- one primary action
- small grouped safe actions
- destructive actions hidden behind confirmation

### Rule 4

Desktop recent events panel becomes a collapsed accordion on mobile.

### Rule 5

Exact commands are always available on both surfaces, but become more important on mobile.

---

## 4.6 Component priority by surface

| Component               | Desktop Home | Desktop Detail | Mobile Home | Mobile Detail |
| ----------------------- | ------------ | -------------- | ----------- | ------------- |
| App shell               | High         | High           | Medium      | Medium        |
| Global status bar       | Medium       | Medium         | Low         | Low           |
| Session table / cards   | High         | No             | High        | No            |
| Profile summary header  | No           | High           | No          | High          |
| State chip              | High         | High           | High        | High          |
| Primary blocker panel   | Medium       | High           | Medium      | High          |
| Recommended next action | High         | High           | High        | High          |
| Pane list / cards       | No           | High           | No          | High          |
| Action rail             | No           | High           | No          | Medium        |
| Exact command panel     | Low          | Medium         | Medium      | High          |
| Recent events           | Low          | Medium         | Low         | Medium        |
| Setup wizard            | No           | Optional       | No          | No            |

---

## 4.7 Layout style guidance

### Desktop

- grid layout
- clear column rhythm
- stronger neon edge accents on active panels
- more simultaneous visibility
- persistent summary + actions above fold

### Mobile

- stacked card layout
- bold state chip first
- one important action above fold
- secondary info collapsible
- finger-sized tap targets
- short labels only

### Shared visual feel

- black or charcoal matte background
- cyan/violet/magenta accents on structure and focus
- sharp corners or lightly rounded corners, not pillowy softness
- bold labels
- monospace for commands and ids
- explicit textual status always present beside color

---

## 4.8 Desktop-specific enhancements allowed later

Allowed later, not required for v1:

- split-pane resizable inspector
- multi-profile comparison mode
- keyboard palette
- event stream pinning

## 4.9 Mobile-specific enhancements allowed later

Allowed later, not required for v1:

- push notification deep links
- quick approve/retry action cards
- biometric protection for destructive actions

---

## 4.10 Hard no list

Do not build:

- mobile drag-and-drop pane layout editor
- desktop marketing-style hero header
- animated telemetry wallpaper
- giant KPI circles with fake health numbers
- floating chatbot assistant inside the cockpit

---

## 5. v1 / v2 Cut Line

## 5.1 Purpose

Freeze what ships in the first real UX implementation versus what is deferred.

This matters because tmux-host is an operator runtime, not a design playground. A bloated v1 would slow implementation, blur boundaries, and create a second-rate dashboard before the host core is even stable.

---

## 5.2 v1 Principles

Ship only what is required to make the host:

- understandable
- operable
- recoverable
- mobile-readable
- visually coherent

Do not ship speculative product features. Do not ship visual cleverness that outruns runtime truth. Do not ship configuration-heavy mobile flows.

---

## 5.3 v1 Required Surfaces

### A. CLI polish

Must ship:

- clear one-line status output
- explicit degraded/missing/unknown failure output
- exact command parity with dashboard actions
- stable labels: `Ensure`, `Attach`, `Respawn`, `Reset Layout`, `Doctor`, `Down`

### B. tmux-native affordances

Must ship:

- pane titles
- compact session/status header
- degraded indicator
- role-based focus helpers
- respawn active pane helper
- reset-layout helper
- dead-pane failure card instead of blank pane

### C. Desktop dashboard

Must ship:

- Session Index screen
- Active Profile Cockpit screen
- state chips
- blocker panel
- recommended next action panel
- pane list
- action rail
- recent events panel
- exact command panel

### D. Mobile-responsive dashboard

Must ship:

- mobile card view for profiles
- mobile profile detail screen
- state chips
- blocker summary
- primary safe action
- exact command fallback
- collapsed recent events

### E. Shared UI state contract

Must ship:

- one canonical state model across CLI, tmux, desktop, and mobile
- no surface-specific aliases
- no fake aggregate health score

---

## 5.4 v1 Optional But Acceptable

These may ship in v1 only if they fall out naturally from the main implementation and do not slow core delivery.

### Optional desktop

- attach handoff panel
- very small global status strip
- setup wizard skeleton without full migration automation

### Optional mobile

- open-terminal handoff link
- copy-command affordance
- lightweight action result banner

### Optional setup

- first-run profile creation wizard, but only if it stays bounded and desktop-only

---

## 5.5 Explicit v1 Deferrals

These are **not** part of v1.

### Configuration and editing

- mobile profile editor
- mobile env editor
- visual pane layout editor
- drag-and-drop layout manipulation
- advanced profile composition UI

### Dashboard expansion

- multi-profile comparison wall
- giant telemetry board
- animated trend theater
- dashboard-only synthetic posture score
- dashboard-owned recovery logic separate from host commands

### Productization creep

- native mobile app
- in-dashboard AI assistant/chat surface
- notification workflow hub with branching automation
- permission and role-management system beyond local operator safety needs

### Setup complexity

- full interactive migration assistant that rewrites shell config automatically
- advanced mobile pairing flow beyond simple handoff / remote awareness

---

## 5.6 v2 Candidate Set

Once host core, lifecycle, and dashboard truth are proven stable, v2 may include:

- desktop setup/migration wizard
- SSH/mobile pairing flow
- richer attach handoff flows
- push or chat notification integration
- multi-profile comparison mode
- keyboard command palette
- better event filtering and pinning
- limited desktop profile editing UI

v2 still should not try to turn mobile into a full terminal cockpit.

---

## 5.7 Release gating for v1 UX

Do not call the UX ready unless all of these are true:

### Required runtime truth gates

- dashboard state matches host runtime state
- mobile and desktop render the same underlying profile states
- every visible action maps to a real host command
- no action performs hidden compound workflows

### Required usability gates

- desktop home answers “what needs action?” immediately
- desktop detail answers “what broke and what do I do next?” immediately
- mobile home answers “is this healthy and what is the one safe action?” immediately
- dead panes show useful failure information

### Required visual gates

- state is readable without relying on color alone
- neon accents improve structure and focus, not noise
- major panels are visually distinct
- compact information density remains legible

---

## 5.8 Recommended implementation order for UX work

### Step 1

Shared state model and action matrix

### Step 2

Desktop Session Index and Profile Cockpit

### Step 3

tmux-native status/header and dead-pane error cards

### Step 4

Mobile responsive layout for existing dashboard

### Step 5

Optional wizard / handoff improvements only after the core surfaces feel solid

This order avoids the very human mistake of polishing mobile fantasies before the real operator surface works.

---

## 5.9 Final v1 definition

v1 is complete when tmux-host has:

- a strong tmux-native working surface
- a truthful desktop supervisory dashboard
- a mobile-readable remote control view with bounded actions
- a shared state model across all surfaces
- bold, neon-edged but still operator-grade visual clarity

If it cannot do those five things cleanly, it is not v1 complete. It is just dressed up.

---

## 6. Immediate Next Step

Next design item:

- generate the UX/UI-focused task packet series
