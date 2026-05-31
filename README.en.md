# aide — AI Driven for Enterprise

**[日本語](README.md)** | English

> **Don't hand everything to AI — humans stay in control and harness it. Spec as the shared language, from requirements through operations: an enterprise framework**

A framework for anyone who works with an IDE/console (PMs, product operators, new-development engineers, existing-system operators) to work alongside AI. It offers a "free mode" that proactively assists even without setup, and a "companion mode" that guides per target segment.

| | |
|---|---|
| **Methodology** | Spec-Driven Development (SDD) + Spec-Anchored (two-way spec sync) + Harness Engineering (V-model reviews) |
| **AI tools** | Claude Code / GitHub Copilot / Codex |
| **Segments** | PM / Product Operations / New Development / Existing Operations (4 segments, single axis) |
| **Positioning** | Enterprise-oriented (audit & traceability are opt-in options) |
| **Environments** | WSL2 / macOS / Linux / **Windows 11 · PowerShell (no WSL2 required)** |

---

## What is aide

Don't leave everything to the AI. Humans decide; specifications are the source of truth; work proceeds incrementally.

- **Free mode (no init)**: Ambiguous instructions trigger a brainstorm suggestion instead of guessing; the work folder is confirmed if unset; once intent is clear, the right skill runs after announcing "Running X" (`aide-advisor`)
- **Companion mode (after init)**: Generates companion tasks per segment and detects getting ahead / rework (`aide-journey`). Only the selected phases get a shallow folder (nothing is created arbitrarily, nothing is written outside the work folder)

```
aide-init          → Initialize: pick segment, work folder, phases, deliverables (selection-based)
aide-advisor      → Free-mode entry: proposes the right skill for an unspecified instruction and runs it after approval
aide-pm-*          → PM (charter/KPI, management, minutes, estimate, slides, retro)
aide-product-*        → Product ops (version-pinned problem solving, issue/config logs)
aide-dev-*         → New development (spec, code, test, migrate) + V-model persona reviews
aide-ops-*         → Existing ops (inquiry/issue/incident → investigate → fix → close)
aide-review        → Launch persona-specific review agents
```

---

## Principles

**Three core principles:**

| Principle | Description |
|---|---|
| **Human-in-the-Loop** | The core of harness engineering. Humans inspect both feedforward (input/spec precision) and feedback (output checked against spec). Embodied by the pre-implementation approval gate and completion-time persona reviews |
| **SSoT** | SDD and Spec-Anchored keep specs always current; both humans and AI converse/decide with documents as the source of truth |
| **Proactive Companion** | Even with nothing specified, insert a confirm/brainstorm step and propose the right skill once intent is clear and run it after your approval |

SSoT supports HITL's feedforward; HITL's feedback keeps SSoT current; the companion principle connects this loop to everyday dialogue.

![aide entry points (free / companion mode) and the three core principles](assets/design-philosophy-principles.drawio.svg)

> aide's entry points are "free mode" and "companion mode." The three core principles are the foundation of companion mode, and free mode also gains precision by invoking the same skills appropriately.

**Operating rules:** selection-based on-demand generation / shallow folders, free interior / never create arbitrarily, never write outside the work folder / index-driven reading

---

## Segments (4, single axis)

| Segment | ID | Purpose |
|---|---|---|
| **PM** | `pm` | KPI/goal setting and project management |
| **Product Operations** | `product` | Product configuration and problem solving (no coding) |
| **New Development** | `dev` | Waterfall × SDD, AI-driven development |
| **Existing Operations** | `ops` | Inquiry / issue / incident handling |

Audit & traceability are opt-in options.

![4 segments (single axis) × 2 usage modes](assets/design-philosophy-segments.drawio.svg)

---

## Quick Start

```bash
# Initialize (interactively pick segment, work folder, phases, deliverables)
/aide-init                 # pm / product / dev / ops (multi-select)

# Or just give an instruction with nothing specified (free mode)
# e.g. "Consider how to handle this incident file" → aide-advisor proposes the right ops skill and runs it after approval
```

See [.aide/README.md](.aide/README.md) for details.

---

## Workflow Overview

| Segment | Flow |
|---|---|
| **PM** | Charter (KPI/goals) → schedule/issues/members → retrospective |
| **Product Ops** | Receive issue → version-pinned official-source search & resolution → config log |
| **New Development** | Requirements → basic design → detail design/impl plan → implementation → unit → integration → system → operation tests (V-model persona review at each completion) |
| **Existing Ops** | Intake (inquiry/issue/incident) → investigate → fix → close |

New Development (dev) runs a persona review at each phase completion along the V-model.

![New Development: SDD / Spec-Anchored / V-model harness](assets/design-philosophy-process.drawio.svg)

---

## Command Reference (27 skills)

### Core (8)
| Command | Purpose |
|---|---|
| `/aide-init` | Pick segment, confirm work folder, selection-based folder generation, profile |
| `/aide-advisor` | Free-mode entry / "what should I do" advisor: analyze location, clarity check, then propose & run after approval |
| `/aide-brainstorm` | Create/update deliverables via brainstorming (catalog-driven) |
| `/aide-sync` | Reflection plan → OK gate → write back to documents |
| `/aide-journey` | Companion tasks; detect getting-ahead / rework |
| `/aide-review` | Launch persona-specific review agents |
| `/aide-diagram` | Generate draw.io-compatible SVG diagrams |
| `/aide-export` | Convert deliverables to HTML/PDF/docx/pptx |

### PM (6)
`/aide-pm-charter` (KPI, goals, charter) / `/aide-pm-manage` (schedule, issues, members) / `/aide-pm-meeting` / `/aide-pm-estimate` / `/aide-pm-slide` / `/aide-pm-retro`

### Product Operations (2)
`/aide-product-resolve` (version-pinned → web search → resolution) / `/aide-product-task` (issue management, config logs)

### New Development (5)
`/aide-dev-spec` (phase deliverables, prior-phase conformance) / `/aide-dev-code` (approval gate, Spec-Anchored) / `/aide-dev-testspec` / `/aide-dev-test` / `/aide-dev-migrate`

### Existing Operations (6)
`/aide-ops-inquiry` / `/aide-ops-issue` / `/aide-ops-incident` / `/aide-ops-investigate` / `/aide-ops-fix` / `/aide-ops-close`

### Review personas (`.aide/agents/`, 9)
requirements / basic-design / detail-design (3 V-model) / code / security / document / source / pm / product-setting reviewer

---

## Customization (never touch .aide)

**`.aide/` is the immutable framework core — never edit it.** All customization happens **outside `.aide/`**, so framework updates (replacing `.aide/`) never collide with your project-specific customizations.

| What | Where (outside .aide) | Core (immutable) | sync |
|---|---|---|---|
| **Rules** | write directly in `CLAUDE.md` / `AGENTS.md` | `.aide/rules.md` | no |
| **Skills** | create your own skills in `.claude/skills/` ・ `.agents/skills/` | `.aide/skills/` | no |
| **Review agents** | create your own agents in `.claude/agents/` | `.aide/agents/` | no |
| **Templates** | put overrides in `.aide-templates/` (project root) | `.aide/templates/` | no |

- **Rules**: keep `.aide/rules.md` untouched; put project-specific rules/profile in `CLAUDE.md` / `AGENTS.md`
- **Skills / agents**: add your own under `.claude/skills/` ・ `.agents/skills/` ・ `.claude/agents/`. sync never deletes or overwrites files it doesn't manage. Overriding an existing `aide-*` skill/persona is not supported — add a differently-named one instead
- **Templates**: the deliverables catalog (`.aide/templates/deliverables-catalog.md`) and outline templates can be overridden by placing same-named files in `.aide-templates/`; skills read `.aide-templates/` first at runtime (no re-sync)

---

## Project Layout (consolidated to 2 systems)

```
.aide/                          ← shared framework (immutable — never edit)
├── rules.md                    ← common rules (master)
├── skills/                     ← skill source (27)
├── agents/                     ← review agent source (9)
├── templates/
│   ├── deliverables-catalog.md ← deliverables catalog
│   ├── deliverables/           ← outline templates
│   └── export/                 ← conversion templates
└── scripts/sync-skills.sh / .ps1  ← wrapper generation (bash / PowerShell)
.aide-templates/                ← ★custom: catalog/template overrides (optional, outside .aide)
CLAUDE.md                       ← Claude Code → @.aide/rules.md + aide profile (★Rules custom)
AGENTS.md                       ← GitHub Copilot + Codex (★Rules custom)
.claude/skills/ , .claude/agents/  ← generated wrappers ＋ ★your own skills/agents
.agents/skills/                 ← generated wrappers ＋ ★your own skills
```

> Only two rule files (**CLAUDE.md** and **AGENTS.md**) and two wrapper systems (**`.claude/skills/`** and **`.agents/skills/`**).
> Copilot reads AGENTS.md + `.agents/skills/`, so `.github/copilot-instructions.md`, `.github/skills/`, and `.github/prompts/` are not used.

### Maintaining skills

```bash
bash .aide/scripts/sync-skills.sh            # POSIX (bash)
pwsh -File .aide/scripts/sync-skills.ps1     # Windows (PowerShell, no WSL2)
```
Edit only the sources (`.aide/skills/`, `.aide/agents/`); regenerate wrappers via sync.

---

## Environments

| Environment | Support |
|---|---|
| WSL2 / macOS / Linux | Recommended (bash sync) |
| **Windows 11 / PowerShell** | **Supported (no WSL2)** — `sync-skills.ps1`; Python via `python`/`py` |
| Git Bash (Windows) | Supported |

- **Required**: Git only
- **For export / Office import**: marked / marp-cli / pandoc / ansi2html / python-pptx / openpyxl, etc. (guided on first use, OS-specific commands)

---

## License

[MIT](LICENSE)
