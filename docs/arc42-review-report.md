# arc42 Documentation Review

**Document under review:** `docs/arc42.adoc` (Single-File layout, Type C)
**Review system:** arc42agentic — full-review orchestrator (12 section agents + 7 conflict agents)
**Sibling artifacts consulted:** `architecture-decisions.adoc`, `specification.adoc`, `PRD.adoc`, `QUESTION_TREE.adoc`, `OPEN_QUESTIONS.adoc`, `entity_model.md`, `use_cases/`
**Note on language:** The documentation is written in English; per the orchestrator's "respect the documentation language" rule, all findings and change proposals are given in English.

## Layout Detection

`docs/arc42.adoc` is a **Single-File (Type C)** arc42 document. All 12 arc42 chapters appear as `==` headings in one AsciiDoc file. Section-to-location mapping:

| arc42 Section | Heading in `arc42.adoc` | Lines |
|---|---|---|
| S1 Introduction and Goals | `== Introduction and Goals` | 11–29 |
| S2 Architecture Constraints | `== Architecture Constraints` | 31–44 |
| S3 Context and Scope | `== Context and Scope` | 46–77 |
| S4 Solution Strategy | `== Solution Strategy` | 79–92 |
| S5 Building Block View | `== Building Block View` | 94–154 |
| S6 Runtime View | `== Runtime View` | 156–189 |
| S7 Deployment View | `== Deployment View` | 191–216 |
| S8 Crosscutting Concepts | `== Crosscutting Concepts` | 218–316 |
| S9 Architecture Decisions | `== Architecture Decisions` | 318–322 |
| S10 Quality Requirements | `== Quality Requirements` | 324–374 |
| S11 Risks and Technical Debt | `== Risks and Technical Debt` | 376–396 |
| S12 Glossary | `== Glossary` | 398–424 |

All 12 chapters are present. No chapter is missing.

## Overall Verdict

🟡 **YELLOW** — The document is structurally complete, evidence-driven, and unusually disciplined for a code-reverse-engineered doc. No critical (🔴) finding was raised. Several yellow (🟡) recommendations remain, mostly around missing stakeholder/quality-goal tables, an under-specified technical context, and the ADR chapter being a bare pointer.

## Section Overview

| Section | Status | Summary |
|---|---|---|
| 1. Introduction and Goals | 🟡 | Requirements overview and quality goals present; no stakeholder table; goal ranking honestly `[OPEN]`. |
| 2. Architecture Constraints | 🟢 | Strong evidence-backed constraint table; categorisation could be sharper. |
| 3. Context and Scope | 🟡 | One context diagram covers business + technical; no separate technical-context channel mapping. |
| 4. Solution Strategy | 🟢 | Compact, references views; quality-goal-to-approach mapping is implicit. |
| 5. Building Block View | 🟡 | Two C4 levels with file mapping; Level-1 blackboxes lack explicit interface descriptions. |
| 6. Runtime View | 🟡 | One well-chosen scenario; error/operational scenarios missing. |
| 7. Deployment View | 🟢 | Adequate for a single-process CLI; environments not differentiated. |
| 8. Crosscutting Concepts | 🟢 | Five mandated concepts present, STRIDE threat catalogue with T-IDs, mitigations cite threats. |
| 9. Architecture Decisions | 🟡 | Chapter body is a one-line pointer; 7 ADRs live in a sibling file, not summarised here. |
| 10. Quality Requirements | 🟢 | Quality tree + 12 measurable code-derived scenarios; satisfies section-10 criteria (see detail). |
| 11. Risks and Technical Debt | 🟡 | Six prioritised risks with evidence; mitigation actions not stated per risk. |
| 12. Glossary | 🟢 | Compact, well-formed term/definition table; consistent with the document. |

---

## Section Reviews

### Section 1: Introduction and Goals

🟡 — Requirements overview and quality goals are present and evidence-backed; the stakeholder content is too thin and lacks the prescribed table form.

#### [S1-01] Stakeholders listed in prose, not as a table

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:28-29`
**Criterion:** arc42 S1.3 — stakeholder table with Role, Name/Description, Expectations

**Finding:** Stakeholders (Developer, Mistral, open-source contributors) are named in a single sentence with no expectations and no operations/management role. arc42 requires a table stating each stakeholder's expectation toward the architecture and its documentation.

**Change proposal:**
> Replace the prose sentence with a table:
> ```
> [cols="1,2,2",options="header"]
> |===
> | Role | Description | Expectation
> | Developer (user) | Runs Vibe in a terminal | Safe, predictable tool execution; resumable sessions
> | Mistral (vendor) | Owns the product and models | Provider-agnostic core; brand-correct defaults
> | Open-source contributor | Extends tools/skills | Stable extension seams, clear build-block map
> | Operator / power user | Configures MCP, auto-approve, telemetry | Documented risk surface of each config flag
> |===
> ```

#### [S1-02] Quality goals not rendered as the prescribed table; ranking `[OPEN]`

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:18-27`
**Criterion:** arc42 S1.2 — quality goals as a table/list, ordered by priority

**Finding:** Three quality goals (Security, Reliability, Extensibility) are given as a bullet list with code evidence — good. The priority order is honestly marked `[OPEN — see Q4.9]`. This `[OPEN]` is legitimate: the code does not declare an authoritative ranking, and the doc says so. No defect. A small improvement would be a table form with an explicit cross-reference to Section 10.

**Change proposal:**
> Add at the end of the quality-goals list: "Each goal is concretised by measurable scenarios in Section 10 (Quality Requirements)." Optionally render the three goals as a 2-column table (Goal | Architectural rationale + evidence).

### Section 2: Architecture Constraints

🟢 — A strong, evidence-anchored constraint table. Every row cites a file. Minor: constraints are not visibly grouped into technical / organisational / conventions.

#### [S2-01] Constraints not categorised

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:33-44`
**Criterion:** arc42 S2 — constraints categorised (technical / organisational / conventions)

**Finding:** All eight constraints sit in one flat table. arc42 recommends grouping. License (Apache-2.0) is organisational; ruff/pyright/`from __future__` are conventions; Python 3.12 / pinned deps are technical.

**Change proposal:**
> Add a "Category" column (Technical / Organisational / Convention) or split into three sub-tables under `=== Technical`, `=== Organisational`, `=== Conventions`.

### Section 3: Context and Scope

🟡 — One context diagram shows the system as a black box with all external partners. A separate **technical context** (channels, protocols, the business-to-technical mapping) is largely absent.

#### [S3-01] No distinct technical context / interface table

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:46-77`
**Criterion:** arc42 S3.2 — technical context: channels, protocols, mapping of business I/O to technical channels

**Finding:** The PlantUML diagram annotates some edges (HTTPS, stdio/http) but there is no accompanying table listing each external partner, the protocol, the data exchanged, and the direction. The business context (S3.1) is adequately covered by the diagram and the scope sentence; the technical context is only implicit. Per the section-3 agent, missing technical context is tolerable but worth a recommendation.

**Change proposal:**
> Add after the diagram:
> ```
> [cols="1,1,2",options="header"]
> |===
> | Partner | Channel / Protocol | Exchanged data
> | LLM Provider API | HTTPS (httpx) | Completion requests, streamed responses
> | MCP Servers | stdio / HTTP | Tool-call requests, tool results
> | OS Shell + Git | Process exec, file I/O | Commands, file contents
> | Vibe Code (Nuage) | HTTPS, AES-256-GCM payload | Teleport session payload
> | PyPI / GitHub | HTTPS | Version-check metadata
> | OS Keyring | Native keyring API | Credentials
> |===
> ```

### Section 4: Solution Strategy

🟢 — Compact, as arc42 requires. It names the layering, the ports-and-adapters pattern, the async model, and the backend factory, and points implicitly to Sections 5 and 8.

#### [S4-01] Quality-goal-to-approach mapping is implicit

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:79-92`
**Criterion:** arc42 S4 — explicit mapping of quality goals (S1.2) to solution approaches

**Finding:** The strategy describes approaches but never names which quality goal each one serves. Extensibility ↔ ports-and-adapters and Reliability ↔ async retry are inferable but not stated.

**Change proposal:**
> Add one sentence per goal, e.g.: "Extensibility is served by ports-and-adapters and the MCP/skill plug-in seams; Reliability by the retry layer (see 8.5); Security by the approval gate and shell denylist (see 8.1/8.2)."

### Section 5: Building Block View

🟡 — Hierarchical: Level 1 (containers) and Level 2 (core components), both as C4-PlantUML, plus a file-to-block list. Blackbox descriptions are thin.

#### [S5-01] Level-1 blackboxes lack explicit interface descriptions

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:96-154`
**Criterion:** arc42 S5.1 — each blackbox states purpose/responsibility AND interface(s)

**Finding:** The block list (lines 144–154) gives each block a one-line responsibility and a file path — purpose and source-code mapping are covered. The **interface(s)** of each block are not stated. arc42 wants at least purpose + interface per blackbox.

**Change proposal:**
> Extend the block list into a table with columns Block | Responsibility | Interface | Source location, e.g. "Agent Loop | turn orchestration | `run_turn()` driven by CLI/ACP | `vibe/core/agent_loop.py`".

#### [S5-02] No rationale for the decomposition

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:94-154`
**Criterion:** arc42 S5.1 — justification for the chosen decomposition

**Finding:** The view shows the decomposition but does not say why it was cut this way. ADR-001 in the sibling file carries this rationale.

**Change proposal:**
> Add one sentence: "The decomposition follows the UI-agnostic-core decision (see Section 9 / ADR-001): core holds domain + agent loop, channels (cli, acp) and integration backends sit outside it."

### Section 6: Runtime View

🟡 — One central scenario (the agent-turn cycle) is well chosen and uses blocks consistent with Section 5. Error and operational scenarios are missing.

#### [S6-01] Only the happy-path turn cycle is shown

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:156-189`
**Criterion:** arc42 S6 — error/exception scenarios and operational scenarios where relevant

**Finding:** The sequence diagram covers the normal turn and tool-approval branch, plus a compaction note. Given that Reliability is a top-3 quality goal and Section 8.5 documents retry/error classification, at least one error/recovery scenario (retryable HTTP failure → backoff → resume, or session resume after crash) should appear as a runtime scenario.

**Change proposal:**
> Add a second short scenario "Retry on transient LLM failure": LLM call → retryable HTTP status → `async_retry` backs off 0.5/1.0/2.0 s → success or non-retryable surfaces as error. Reference `utils/retry.py` and `agent_loop.py:166-187`.

### Section 7: Deployment View

🟢 — A deployment diagram plus prose covers the three distribution forms and the single-process model. Adequate for a non-distributed local CLI; the section-7 agent explicitly tolerates a minimal view here.

#### [S7-01] Environments (dev/test/prod) not differentiated

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:191-216`
**Criterion:** arc42 S7.1 — document the different environments

**Finding:** Only the end-user developer machine is shown. The CI environment (`.github/workflows/ci.yml`, referenced in Section 8.3) is a second relevant environment.

**Change proposal:**
> Add one sentence noting CI as a separate environment: "Besides the developer machine, the GitHub Actions CI runner builds, lints and tests every change (`.github/workflows/ci.yml`)."

### Section 8: Crosscutting Concepts

🟢 — The strongest chapter. All five mandated concepts (8.1 Threat Model, 8.2 Security, 8.3 Test, 8.4 Observability, 8.5 Error Handling) are present, sub-numbered, and explained — not merely named. The STRIDE threat catalogue assigns T-IDs and the security mitigations each cite the T-IDs they close. T-005 honestly states it has no code-level mitigation.

#### [S8-01] No domain/entity model in the concepts chapter

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:218-316`
**Criterion:** arc42 S8 — document at least one domain/data model

**Finding:** A sibling `entity_model.md` exists but Section 8 never references it. arc42 lists a domain model among crosscutting concepts.

**Change proposal:**
> Add a short `=== 8.6 Domain Model` subsection or a sentence under 8.x: "The persisted-data and domain entities (Session, Turn, Tool, Skill, Config layers) are modelled in `docs/entity_model.md`."

#### [S8-02] Error Handling: circuit breaker absence stated, recovery good

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:303-316`
**Criterion:** Crosscutting-concepts contract 8.5 — retry, circuit breaker, fallback, recovery

**Finding:** Retry, error classification, timeout/fallback and recovery are all covered. The doc explicitly states no circuit breaker was found. This is honest and correct — not a defect; noted only for completeness.

### Section 9: Architecture Decisions

🟡 — The chapter body is a single sentence pointing to `architecture-decisions.adoc`. The seven ADRs in that sibling file **do** follow Nygard (Status / Context / Decision / Consequences) and include 3-point Pugh matrices, with `?` for team-judgment cells — well-formed. But the arc42 chapter itself carries no decision list.

#### [S9-01] Section 9 has no in-document decision summary

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:318-322`
**Criterion:** arc42 S9 — architecturally relevant decisions documented in the section

**Finding:** A reader of `arc42.adoc` alone sees no decisions at all — only a pointer. arc42 allows ADRs to live in a register, but the chapter should at least list the ADR titles, their status, and a one-line summary so the document is self-contained.

**Change proposal:**
> Add an ADR index table to the chapter:
> ```
> [cols="1,3,1",options="header"]
> |===
> | ADR | Title | Status
> | ADR-001 | Layered package with a UI-agnostic core | Accepted (inferred)
> | ADR-002 | Ports-and-adapters at integration seams | Accepted (inferred)
> | ADR-003 | Five LLM backends behind one factory | Accepted (inferred)
> | ADR-004 | Restrict the bash tool with a denylist, not a sandbox | Accepted (inferred)
> | ADR-005 | Approval-gated tool execution with agent profiles | Accepted (inferred)
> | ADR-006 | Disk-based persistence (TOML + JSON), no database | Accepted (inferred)
> | ADR-007 | Exact pinning of mistralai and agent-client-protocol | Accepted (inferred)
> |===
> ```

#### [S9-02] "Accepted (inferred)" is non-standard Nygard status — but justified

**Severity:** 🟢 Hint
**File:** `architecture-decisions.adoc` (all ADRs)
**Criterion:** arc42 S9 / Nygard — Status is one of proposed/accepted/deprecated/superseded

**Finding:** Every ADR uses Status "Accepted (inferred)". This is not a literal Nygard value, but the project contract explicitly mandates this label for reverse-engineered decisions, and the file states the rationale. Honest gap, not a defect.

### Section 10: Quality Requirements

🟢 — **This chapter satisfies the section-10 review criteria.** It contains a quality tree (six characteristics, mapped to architectural mechanisms) and **12 quality scenarios (QS-1…QS-12)** in a four-column table: ID, Characteristic, Scenario (stimulus → response, measured), Evidence. See the detailed assessment below.

#### Detailed assessment against section-10 criteria

**10.1 Quality overview:** Present as the "Quality Tree" — six characteristics (Security, Reliability, Performance Efficiency, Extensibility/Maintainability, Compatibility, Portability), each tied to concrete mechanisms. Categorisation aligns with ISO 25010. ✅

**10.2 Quality scenarios — formal:** Each QS row has a stimulus, a response, and a **measured threshold** with file:line evidence. Examples: QS-1 "complete or abort within 720 s" (`_settings.py:520`); QS-7 "retried 3 times with 0.5→1.0→2.0 s backoff" (`utils/retry.py`); QS-10 "denylist-matching command rejected before execution" (`bash.py:120-147`). Every scenario is falsifiable and could serve as an acceptance criterion. ✅

**10.2 — scenario type coverage:** Usage/performance scenarios (QS-1…QS-6), change/maintainability scenario (QS-11), fault/failure scenarios (QS-7 retry, QS-12 snapshot regression, QS-8 loop-limit rejection). All three required scenario types are covered. ✅

**Consistency with Section 1.2:** All three Section-1.2 quality goals are concretised — Security by QS-9, QS-10; Reliability by QS-6, QS-7, QS-8, QS-12; Extensibility/Maintainability by QS-11. The chapter does **not** carry a bare `[OPEN]` pointer in place of scenarios — it delivers the derivable scenarios, exactly as the Socratic-recovery contract demands. ✅

**Honest gaps:** Only the priority *ranking* of characteristics is `[OPEN — see Q4.9]`, correctly flagged as not derivable from code.

#### [S10-01] Extensibility goal has only one scenario; ranking `[OPEN]`

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:338-374`
**Criterion:** arc42 S10 — every Section-1.2 goal concretised; balanced scenario weight

**Finding:** Extensibility — a top-3 goal — is concretised by a single scenario (QS-11, the lint gate), which is really a maintainability gate rather than an extensibility (plug-in) scenario. Performance, by contrast, has six scenarios. Not a defect (the code's measurable surface for extensibility is genuinely thin), but worth noting.

**Change proposal:**
> Add one extensibility scenario if a measurable hook exists, e.g. "A new MCP server is added to config; its tools become available to the agent loop without any code change to `vibe/core`." Evidence: `vibe/core/tools/mcp/`. If no measurable threshold exists, keep as-is and note it.

#### [S10-02] No explicit cross-link from QS rows back to Section-1.2 goals

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:340-370`
**Criterion:** arc42 S10 — scenarios traceable to Section 1.2 goals

**Finding:** The mapping goal→scenario is inferable from the "Characteristic" column but never stated explicitly.

**Change proposal:**
> Add a sentence before the table: "QS-9/QS-10 concretise the Security goal, QS-6/QS-7/QS-8/QS-12 the Reliability goal, QS-11 the Extensibility/Maintainability goal (see Section 1.2)."

### Section 11: Risks and Technical Debt

🟡 — Six risks (R-1…R-6) in a prioritised table, each with a description and evidence/Q-ID. The technical-debt register is honestly `[OPEN]`. Mitigation actions are not stated per risk.

#### [S11-01] Risks have no mitigation/action column

**Severity:** 🟡 Recommendation
**File:** `docs/arc42.adoc:378-396`
**Criterion:** arc42 S11 — propose measures to mitigate/avoid/reduce each risk

**Finding:** The table has Risk / Description / Evidence but no "Mitigation" column. arc42 expects a proposed measure per risk. Some mitigations already exist in Section 8.2 (e.g. R-1 → tool-approval gate, shell denylist) and should be cross-referenced; others (R-5 no SBOM gate) need a proposed action.

**Change proposal:**
> Add a "Mitigation / Action" column: R-1 → "approval gate + shell denylist (8.2); discourage `auto-approve` in docs"; R-2 → "ADR-007 deliberate; schedule periodic manual upgrade review"; R-3 → "lower default `api_timeout`; surface progress to user"; R-4 → "split `agent_loop.py` (Mikado)"; R-5 → "add `pip-audit`/SBOM step to release pipeline"; R-6 → "add Windows CI job or document UNIX-only support clearly".

#### [S11-02] `[OPEN]` items in Section 11 are correctly scoped

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:391,396`
**Criterion:** Honest-gap judgement

**Finding:** R-5 (no SBOM gate) and the technical-debt register are marked `[OPEN]`. R-5's *existence* is actually code/CI-derivable (the absence of an audit step in `.github/workflows/`) — the doc already states it as a risk, so the `[OPEN]` tag on `Q5.4-sbom` is about the team *decision* to add one, which is legitimately open. The debt register being `[OPEN]` is an honest gap (it needs team prioritisation). No over-claiming detected.

### Section 12: Glossary

🟢 — A compact two-column term/definition table covering the domain vocabulary (Agent Loop, Agent Profile, Tool, MCP Server, Connector, Skill, Session, Compaction, Trusted Folder, ACP, Nuage, Thinking level, Hook). Terms are used consistently across the document.

#### [S12-01] Terms not strictly alphabetically ordered

**Severity:** 🟢 Hint
**File:** `docs/arc42.adoc:400-424`
**Criterion:** arc42 S12 — terms ordered alphabetically or logically

**Finding:** The order is roughly logical (importance-grouped), not alphabetical. Acceptable per the criterion, noted only for polish. One term used in the body — "teleport" (Sections 3, 8.1, glossary entry "Nuage") — is defined only indirectly.

**Change proposal:**
> Either sort alphabetically, or add a glossary row: "Teleport | Handing a running session over to the Vibe Code remote workflow backend."

---

## Cross-Section Conflicts

| Conflict Dimension | Status | Summary |
|---|---|---|
| Quality strand (S1 ↔ S4 ↔ S10) | 🟡 | All goals traced to strategy and scenarios; goal→approach link implicit; priority `[OPEN]` consistent. |
| Strategy ↔ Decisions (S4 ↔ S9) | 🟢 | Strategy and ADRs align; no contradiction, no harmful redundancy. |
| Constraint Compliance (S2 ↔ S4/S8/S9) | 🟢 | No constraint violated by strategy, concepts or decisions. |
| Context ↔ Building Blocks (S3 ↔ S5) | 🟡 | External partners mostly consistent; OS Keyring appears in S3 but not in the S5 Level-1 diagram. |
| Views Consistency (S5 ↔ S6 ↔ S7) | 🟡 | Runtime/deployment blocks trace to S5; several S5 blocks appear in no scenario or deployment. |
| Concepts ↔ Decisions (S8 ↔ S9) | 🟢 | Clean WHAT/HOW split; concepts and ADRs reinforce each other. |
| Risks ↔ Quality (S11 ↔ S1/S10) | 🟡 | Risks map to quality goals; some quality risks lack a stated mitigation. |

### 1. Quality Strand (S1 ↔ S4 ↔ S10)

**Mapping matrix**

| Quality goal (S1.2) | Strategy approach (S4) | Scenario (S10) | Status |
|---|---|---|---|
| Security | Approval gate, shell denylist (via 8.x; S4 only implies) | QS-9, QS-10 | ⚠️ Gap (S4 link implicit) |
| Reliability | Async retry (S4 mentions async; retry in 8.5) | QS-6, QS-7, QS-8, QS-12 | ⚠️ Gap (S4 link implicit) |
| Extensibility | Ports-and-adapters, MCP/skill seams (S4 explicit) | QS-11 | ✅ Consistent |

#### [KQS-01] Strategy does not explicitly name the quality goals it serves

**Conflict type:** K1
**Severity:** 🟡 Warning
**Affected files:**
- `docs/arc42.adoc:79-92` — Solution Strategy describes approaches without goal attribution
- `docs/arc42.adoc:18-27` — Section 1.2 quality goals

**Description:** Each Section-1.2 goal *is* addressed somewhere, but Section 4 never states which approach serves which goal. The quality strand is traceable only by inference. Section 10 closes the strand well (every goal has measured scenarios), so this is a documentation-linkage gap, not a substantive contradiction.

**Resolution:** Apply change proposal [S4-01] — add one sentence per goal in Section 4 mapping it to its approach and to Section 8/10.

### 2. Strategy ↔ Decisions (S4 ↔ S9)

**Mapping matrix**

| Strategic statement (S4) | Related ADR(s) (S9) | Status |
|---|---|---|
| Layered package, UI-agnostic core | ADR-001 | ✅ Aligned |
| Ports-and-adapters at seams | ADR-002 | ✅ Aligned |
| Five backends behind one factory | ADR-003 | ✅ Aligned |
| Async end-to-end | — (no ADR) | 🔲 Minor gap (acceptable) |

No conflicts. Strategy and the seven ADRs are consistent and non-redundant — the ADRs add context, Pugh matrices and consequences the strategy does not duplicate. The async-everywhere choice has no ADR, which is acceptable (a low-controversy technical choice).

### 3. Constraint Compliance (S2 ↔ S4/S8/S9)

**Constraint-compliance matrix (abridged)**

| Constraint (S2) | S4 | S8 | S9 | Status |
|---|---|---|---|---|
| Python ≥ 3.12 | ✅ | ✅ | ✅ | OK |
| Apache-2.0 license | ✅ | ✅ | ✅ | OK |
| Exact pins mistralai / acp | ✅ | ✅ | ✅ (ADR-007) | OK |
| ruff/pyright/vulture/typos pre-commit | ✅ | ✅ (8.3) | ✅ | OK |
| Per-function 50 stmt / 15 branch limit | ✅ | ✅ (QS-11) | ✅ | OK |

No constraint is violated. Note: R-4 (`agent_loop.py` > 1300 lines) is a tension *against the spirit* of the per-function size limits, but the constraint is per-function, not per-file, so there is no formal violation — correctly recorded as a risk rather than a conflict.

### 4. Context ↔ Building Blocks (S3 ↔ S5)

**Interface comparison**

| External partner | In Context (S3) | In Building Block View (S5) | Status |
|---|---|---|---|
| LLM Provider API | ✅ | ✅ (System_Ext provider) | ✅ Consistent |
| MCP Servers | ✅ | ✅ (System_Ext mcp) | ✅ Consistent |
| Connectors | ✅ | ⚠️ folded into "MCP Servers / Connectors" | 🟢 Naming |
| OS Shell + Git | ✅ | ❌ not in Level-1 C4 diagram | ⚠️ Gap |
| Vibe Code / Nuage | ✅ | ⚠️ only as internal "Nuage Client" component | 🟢 Boundary |
| PyPI / GitHub (updates) | ✅ | ❌ not in Level-1 diagram | ⚠️ Gap |
| OS Keyring | ✅ | ❌ not in Level-1 diagram | ⚠️ Gap |

#### [KKB-01] Several context partners absent from the building-block Level-1 diagram

**Conflict type:** K1
**Severity:** 🟡 Warning
**Affected files:**
- `docs/arc42.adoc:51-74` — Context diagram shows OS Shell, PyPI/GitHub, OS Keyring
- `docs/arc42.adoc:98-119` — C4 Level-1 diagram shows only provider and MCP as `System_Ext`

**Description:** The Section-3 context lists seven external partners; the Section-5 Level-1 C4 diagram externalises only two (provider, MCP). OS Shell+Git, PyPI/GitHub and OS Keyring — all genuine external interfaces in S3 — have no counterpart in the building-block view. The Level-2 component diagram does include a Nuage Client, partially covering the teleport partner.

**Resolution:** Add `System_Ext` nodes for OS Shell+Git, PyPI/GitHub and OS Keyring to the Level-1 C4 diagram, with `Rel` edges from `core` (or `cli`), so the two views show the same system boundary.

### 5. Views Consistency (S5 ↔ S6 ↔ S7)

**Block cross-reference**

| Block (S5) | Building Block (S5) | Runtime (S6) | Deployment (S7) | Status |
|---|---|---|---|---|
| Agent Loop | ✅ | ✅ | ✅ (in process) | ✅ Consistent |
| LLM Backend Factory | ✅ | ✅ ("LLM Backend") | ✅ | ✅ Consistent |
| Permission Manager | ✅ | ✅ ("Permission Mgr") | ✅ | ✅ Consistent |
| Tool Subsystem | ✅ | ✅ ("Tool") | ✅ | ✅ Consistent |
| Config Subsystem | ✅ | ❌ | ❌ | ⚠️ Orphan |
| Session Subsystem | ✅ | ❌ (only a note) | ❌ | ⚠️ Orphan |
| Skills | ✅ | ❌ | ❌ | ⚠️ Orphan |
| Nuage Client | ✅ | ❌ | ❌ | ⚠️ Orphan |

#### [KSV-01] Four Level-2 blocks appear in no runtime scenario and no deployment

**Conflict type:** K3
**Severity:** 🟡 Warning
**Affected files:**
- `docs/arc42.adoc:144-154` — S5 defines Config, Session, Skills, Nuage Client
- `docs/arc42.adoc:160-189` — S6 has only the turn-cycle scenario
- `docs/arc42.adoc:193-216` — S7 deployment

**Description:** Config, Session, Skills and Nuage Client are defined in Section 5 but never appear in a runtime scenario or in the deployment view. The single happy-path scenario cannot exercise them. This is a coverage gap, not a contradiction — the section-6 finding [S6-01] (add more scenarios) is the underlying cause.

**Resolution:** Add runtime scenarios that exercise these blocks — e.g. "session resume", "skill invoked as slash command", "teleport to Vibe Code". This also resolves [S6-01]. Deployment need not list them individually (all run in one process); a note "all core subsystems run in the single `vibe` process" suffices.

#### [KSV-02] Runtime "LLM Backend" vs. building-block "LLM Backend Factory"

**Conflict type:** K3 (naming)
**Severity:** 🟢 Hint
**Affected files:**
- `docs/arc42.adoc:165` — S6 participant "LLM Backend"
- `docs/arc42.adoc:107,152` — S5 block "LLM Backend Factory"

**Description:** Minor naming drift between views.

**Resolution:** Use one name consistently — "LLM Backend Factory" — in the runtime sequence diagram.

### 6. Concepts ↔ Decisions (S8 ↔ S9)

**Classification analysis (abridged)**

| Element | Section | Correct placement? | Note |
|---|---|---|---|
| 8.1 Threat Model (STRIDE) | S8 | ✅ Correct | A crosscutting concept (HOW) |
| 8.2 Security mitigations | S8 | ✅ Correct | HOW; references ADR-004/005 implicitly |
| 8.3 Test / 8.4 Observability / 8.5 Error Handling | S8 | ✅ Correct | All HOW-patterns |
| Denylist vs. sandbox | S9 (ADR-004) | ✅ Correct | A decision (WHAT/WHY) |
| Approval gate + profiles | S9 (ADR-005) | ✅ Correct | A decision |

No conflicts. The WHAT/HOW split is clean: the denylist *decision* lives in ADR-004, the denylist *mechanism* in 8.2; the approval-gate *decision* in ADR-005, its *mechanism* in 8.2. Concepts and decisions reinforce each other.

#### [KKE-01] Security concepts do not back-reference their ADRs

**Conflict type:** K4 (linkage, not a real gap)
**Severity:** 🟢 Hint
**Affected files:**
- `docs/arc42.adoc:248-271` — 8.2 Security
- `architecture-decisions.adoc` — ADR-004, ADR-005

**Description:** The shell denylist (8.2) and the tool-approval gate (8.2) are exactly the mechanisms decided in ADR-004 and ADR-005, but Section 8 never cites them. The decision exists; only the cross-reference is missing.

**Resolution:** Add "(see ADR-004)" after the shell-denylist bullet and "(see ADR-005)" after the tool-approval-gate bullet in Section 8.2.

### 7. Risks ↔ Quality (S11 ↔ S1/S10)

**Mapping matrix**

| Quality goal (S1.2) | Threatening risk (S11) | Mitigation | Status |
|---|---|---|---|
| Security | R-1 (destructive shell command) | Approval gate, denylist (8.2) — not stated in S11 | ⚠️ Gap |
| Reliability | R-3 (hung LLM call 12 min) | `api_timeout` (8.2/QS-1) — not stated in S11 | ⚠️ Gap |
| Maintainability | R-4 (large modules) | none stated | ⚠️ Gap |
| Security (supply chain) | R-2, R-5 (pin drift, no SBOM) | partial (R-2 ↔ ADR-007) | ⚠️ Gap |
| Portability | R-6 (Windows best-effort) | none stated | ⚠️ Gap |

#### [KRQ-01] Quality-threatening risks lack stated mitigations

**Conflict type:** K2
**Severity:** 🟡 Warning
**Affected files:**
- `docs/arc42.adoc:378-396` — Section 11 risk table (no mitigation column)
- `docs/arc42.adoc:248-271,344-345` — mitigations that exist in Section 8.2 / Section 10

**Description:** R-1 and R-3 clearly threaten the top-2 quality goals (Security, Reliability). Mitigations for both already exist in Section 8.2 and Section 10 (QS-1, QS-9, QS-10) but Section 11 does not name or cross-reference them, so a reader of Section 11 alone sees unmitigated risks. This is the cross-section twin of [S11-01].

**Resolution:** Apply [S11-01] — add a Mitigation column to the Section-11 table, cross-referencing Section 8.2 and the relevant QS IDs.

#### [KRQ-02] No risk recorded against the Extensibility quality goal

**Conflict type:** K1
**Severity:** 🟢 Hint
**Affected files:**
- `docs/arc42.adoc:18-27` — Extensibility is a top-3 quality goal
- `docs/arc42.adoc:378-396` — Section 11 has no extensibility risk

**Description:** Extensibility relies on MCP, connectors and skills (third-party plug-in surfaces). T-005 (MCP child-process trust) in Section 8.1 already shows extensibility carries a risk, yet Section 11 records no extensibility risk. Per the conflict agent this is acceptable only if the architecture fully secures the goal — which T-005 shows it does not.

**Resolution:** Add a risk row, e.g. "R-7 | A misbehaving or hostile MCP server / connector degrades or compromises a session | T-005, Q5.2".

---

## Conflict Map

| Section | Involved in conflicts |
|---|---|
| S5 — Building Block View | 3 (KKB-01, KSV-01, KSV-02) |
| S10 — Quality Requirements | 3 (KQS-01, KRQ-01, KRQ-02) |
| S1 — Introduction/Goals | 3 (KQS-01, KRQ-01, KRQ-02) |
| S11 — Risks | 2 (KRQ-01, KRQ-02) |
| S3 — Context | 1 (KKB-01) |
| S4 — Solution Strategy | 1 (KQS-01) |
| S6 — Runtime View | 1 (KSV-01) |
| S7 — Deployment View | 1 (KSV-01) |
| S8 — Concepts | 1 (KKE-01) |
| S9 — Decisions | 1 (KKE-01) |

**Total cross-section conflicts: 7** (0 critical, 4 warnings, 3 hints).

## Summary

| Category | Count |
|---|---|
| 🔴 Critical findings | 0 |
| 🟡 Warnings / Recommendations | 11 |
| 🟢 Hints | 16 |

(Section findings: 5 🟡 + 11 🟢. Conflict findings: 4 🟡 + 3 🟢 + 0 🔴.)

### Honest-gap vs. defect note

The document was reverse-engineered from code with no team available. The `[OPEN]` markers were checked:

- **Legitimate honest gaps:** quality-goal priority ranking (Q4.9), technical-debt register (Q5.1), T-005 MCP-trust mitigation, the SBOM *decision* (Q5.4-sbom), ADR-007 stability-vs-updates tie. None of these is answerable from code alone.
- **Over-claiming check:** No over-claiming found. The doc is conservative — it explicitly states "no circuit breaker was found", "no ADR records exist", "Status Accepted (inferred)", and marks the goal ranking open rather than inventing one. Section 10 delivers 12 real, measured, code-cited scenarios instead of a bare `[OPEN]` pointer, exactly as required.
- **`[OPEN]` that is partly code-derivable:** R-5's *existence* (no SBOM/CVE gate in `.github/workflows/`) is code/CI-observable and the doc already records it as a concrete risk; only the *decision* to add a gate is open. No correction needed.

### Recommended Actions (priority order)

1. **[KKB-01 / S3-01]** Reconcile the system boundary: add OS Shell+Git, PyPI/GitHub and OS Keyring as `System_Ext` nodes in the Section-5 Level-1 C4 diagram, and add a technical-context interface table to Section 3.
2. **[KRQ-01 / S11-01]** Add a "Mitigation / Action" column to the Section-11 risk table, cross-referencing Section 8.2 and the QS IDs.
3. **[KSV-01 / S6-01]** Add 2–3 runtime scenarios (retry-on-failure, session resume, skill invocation) so Config, Session, Skills and Nuage Client are exercised in the runtime view.
4. **[S9-01]** Add an ADR index table to Section 9 so the arc42 document is self-contained.
5. **[S1-01]** Replace the prose stakeholder sentence with a proper stakeholder table including expectations and an operations/power-user role.
6. **[KQS-01 / S4-01]** State explicitly in Section 4 which solution approach serves which quality goal.
7. **[KRQ-02]** Add an extensibility risk (R-7, MCP/connector trust) to Section 11.

### Note on Chapter 10

Chapter 10 scores 🟢 **GREEN**. The 12 code-derived quality scenarios (QS-1…QS-12) **satisfy the section-10 review criteria**: each is a formal stimulus→response scenario with a measured, falsifiable threshold and file:line evidence; usage, change and fault scenario types are all covered; all three Section-1.2 quality goals are concretised; and the chapter delivers derivable scenarios rather than a bare `[OPEN]` pointer. The only `[OPEN]` is the characteristic *ranking* (Q4.9), which is correctly not derivable from code. The two open hints ([S10-01] thin Extensibility coverage, [S10-02] missing explicit goal→scenario cross-link) are polish items, not defects.
