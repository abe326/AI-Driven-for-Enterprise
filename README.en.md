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

### What you can customize × how to specify it (overview)

| # | What | Where (outside `.aide`) | How to specify | Resolution | Core (immutable) |
|---|---|---|---|---|---|
| 1 | **Rules** (project-specific) | `CLAUDE.md` / `AGENTS.md` | append directly to the file | override = append (layered on top of shared rules) | `.aide/rules.md` |
| 2 | **Deliverables catalog** (which deliverables per phase) | `.aide-templates/deliverables-catalog.md` | place a same-named file based on the master | **override** (project side wins) | `.aide/templates/deliverables-catalog.md` |
| 3 | **Outline templates** (deliverable structure) | `.aide-templates/deliverables/<name>.md` | place a same-named file based on the master | **override** (whole-file replacement) | `.aide/templates/deliverables/<name>.md` |
| 4 | **Export HTML** (estimate / schedule / discussion / generic doc) | `.aide-templates/export/<type>/<file>` | place a same-named file at the same relative path | **override** (same name wins) | `.aide/templates/export/<type>/` |
| 5 | **Slide themes** (colors, logo, drawing rules) | `.aide-templates/export/slide/themes/<name>/` | add a theme-name folder | **addition (union)** / overrides only when same-named | `.aide/templates/export/slide/themes/` |
| 6 | **Custom skills** | `.claude/skills/<name>/` ・ `.agents/skills/<name>/` | create a new skill directly | addition (sync never deletes/touches) | `.aide/skills/` |
| 7 | **Custom review agents** | `.claude/agents/<name>.md` | create a new agent directly | addition (sync never deletes/touches) | `.aide/agents/` |
| 8 | **Project default slide theme** | aide profile in `CLAUDE.md` | write a `スライドテーマ: <name>` line | profile reference (per-file frontmatter wins) | — |

> **Override vs. addition**
> - **Override** (2・3・4) = placing a file with the **same name** on the project side makes skills read the project side **first** at runtime (the master is not read). Replacement style.
> - **Addition (union)** (5) = the master themes stay, and the **choices grow**. The project side wins only when a folder has the same name.
> - Templates (2–5) are **no-sync / instant** — skills read `.aide-templates/` → `.aide/templates/` in that order at runtime.

> **What you cannot customize (intentional constraints)**
> - **Overriding the behavior of an existing `aide-*` skill / review persona is not supported.** Use framework-provided assets as-is; to change behavior, **add a differently-named one** (6・7).
> - Editing the shared `.aide/rules.md` directly is not allowed — put project specifics in `CLAUDE.md` / `AGENTS.md` (1).

### Rules (project-specific)

- Keep the shared `.aide/rules.md` **untouched**; write project-specific rules/policies directly in `CLAUDE.md` (Claude Code) / `AGENTS.md` (Copilot, Codex)
- Running `aide-init` replaces `CLAUDE.md` with project-specific settings (`@.aide/rules.md` reference + aide profile). The profile (segment, working folder, active phases, etc.) is managed here too

**Example** (`CLAUDE.md`):

```markdown
@.aide/rules.md

## aideプロファイル
- セグメント: dev
- 作業フォルダ: docs/
- スライドテーマ: corporate     # project default theme (#8)

## Project-specific rules
- Write commit messages in Japanese
- Always link the design-doc section number in commits
```

### Skills / review agents

- Create custom skills directly under `.claude/skills/` (Claude Code) and, if needed, `.agents/skills/` (Copilot, Codex). For multi-tool use, place them in each system
- Create custom review agents directly under `.claude/agents/`
- sync **never deletes or overwrites** skills/agents it doesn't manage, so they coexist (no `sync` needed)
- **Overriding an existing `aide-*` skill / review persona's behavior is not supported.** Use the framework assets as-is; to change behavior, **add a differently-named custom skill / agent**

**Example** (adding a custom skill):

```
.claude/skills/my-release-note/SKILL.md   # custom skill (added under a different name)
.claude/agents/my-api-reviewer.md         # custom review agent
```

### Templates (deliverable templates)

- Put catalog / outline-template overrides in **`.aide-templates/`** at the project root (outside `.aide/`)
  - `.aide-templates/deliverables-catalog.md` … catalog override (#2)
  - `.aide-templates/deliverables/<name>.md` … outline-template override (#3)
- Skills (`aide-init` / `aide-brainstorm` / `aide-dev-spec` / `aide-pm-charter`, etc.) read `.aide-templates/` **first** at runtime, falling back to `.aide/templates/`
- Keep the master `.aide/templates/` untouched. Skills read it directly at runtime, so changes are **instant** (no `sync`)
- `aide-init` can **auto-generate** `.aide-templates/` from the master when you answer Yes to "adjust the standard menu?" (no manual work)
- Outline templates are replaced **whole-file**. Even to add a single section you copy and edit the master, so master-side updates do **not** auto-propagate to your override

**Example** (replacing the requirements outline for a project):

```
.aide-templates/deliverables/requirements.md   # copy the master and add/edit sections
```

### Export / slide themes

- Conversion templates live under `.aide/templates/export/` organized **per output type** (`slide/` `document/` `estimate/` `schedule/` `discussion/`)
- **Single-file** templates such as HTML are **overridden** by placing a same-named file at `.aide-templates/export/<type>/<file>` (#4)
- **Slide themes are *added*, not overwritten** (#5). Drop `.aide-templates/export/slide/themes/<name>/` and it joins the master themes (`corporate`, `proposal`) as a **union** of choices
  - **Naming rule**: folder name = the CSS header `/* @theme <name> */` = the MD frontmatter `theme:` value must **match** (default `corporate`)
  - Theme folder layout: `theme.css` (required) plus optional `assets/` (images, logos) and `rules.md` (theme-specific drawing rules)
  - To change only the default colors, place a same-named `.aide-templates/export/slide/themes/corporate/theme.css` so the project side wins

**Example** (adding and using a project theme):

```css
/* .aide-templates/export/slide/themes/acme/theme.css */
/* @theme acme */
:root {
  --color-primary: #16a34a;   /* swap in your project's brand color */
  --color-accent:  #15803d;
}
```

```markdown
---
marp: true
theme: acme        # ← choose the theme via the MD frontmatter (#5)
---
```

> Which theme is used is specified by the slide MD's frontmatter `theme:` (a standard Marp key). The project default theme can be set via the `スライドテーマ:` line in the `CLAUDE.md` profile (#8); per-file frontmatter takes precedence.

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
│   └── export/                 ← conversion templates (per output type)
│       ├── slide/              ←   slide-template.md ＋ themes/<name>/theme.css
│       ├── document/ estimate/ schedule/ discussion/  ← HTML templates
│       └── metadata.yaml / scripts/  ← shared metadata & conversion scripts
└── scripts/sync-skills.sh / .ps1  ← wrapper generation (bash / PowerShell)
.aide-templates/                ← ★custom: catalog/template/export overrides & slide-theme additions (optional, outside .aide)
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
