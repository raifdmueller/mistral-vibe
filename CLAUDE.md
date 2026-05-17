
## Specification

When we talk about a "specification" or "spec", we mean:
- Persona Use Cases in Cockburn's Fully Dressed format (Primary Actor, Trigger, Main Success Scenario, Extensions, Postconditions) at User Goal level, with Business Rules (BR-IDs)
- System Use Cases for each technical interface (API endpoint, CLI command, event, file format): input/validation, processing, output/status codes, error responses
- Activity Diagrams for all flows (not just the happy path)
- Acceptance criteria in Gherkin format (Given/When/Then)
- Individual requirements in EARS syntax where applicable (When/While/If/Shall)
- Supplementary Specifications as needed: Entity Model, State Machines, Interface Contracts, Validation Rules

## Requirements Discovery

Clarify requirements using the Socratic Method:
- Ask at most 3 questions at a time, challenge assumptions
- Use MECE to ensure questions cover all areas without overlap
- Keep asking until you fully understand the requirements

Frame the scope before writing it down:
- Impact Mapping connects deliverables to business goals and actors — so you build what moves a goal, not just what was asked.
- User Story Mapping lays stories along the user's journey and exposes a coherent first slice.

Document the result as a PRD (problem, goals, personas, success criteria, scope).

## Architecture Documentation

Architecture documentation follows arc42.

Every context, building-block and runtime chapter carries at least one diagram. Diagrams are PlantUML, not Mermaid; building blocks use C4 with the C4-PlantUML standard library (local include, not the remote URL — Kroki cannot fetch it), not generic boxes.

Decisions are ADRs (Nygard) with a 3-point Pugh Matrix (-1/0/+1). When the rationale is unconfirmed, ADR Status is "Accepted (inferred)" and Pugh cells needing team judgment are marked `?` rather than guessed.

## Crosscutting Concepts

arc42 leaves Chapter 8 open. We require five baseline crosscutting concepts, in this order:

- 8.1 Threat Model — STRIDE; threats get IDs (T-001…).
- 8.2 Security — every mitigation references the T-IDs it closes.
- 8.3 Test — testing pyramid; tests trace to Use Cases and Business Rules.
- 8.4 Observability — logs, metrics, traces, audit trails.
- 8.5 Error Handling — retry, circuit breaker, fallback, recovery.

Add further Chapter 8.x concepts (persistence, i18n, accessibility, configuration, performance) only when the system actually has that concern.

## Layer Boundaries

At every layer boundary:
- Expose only well-defined DTOs and contracts — never domain entities
- Use explicit mapping at every seam
- Apply Anti-Corruption Layers when integrating external systems
- Dependency direction points inward (DIP)

## Backlog Management

Create EPICs and User Stories as GitHub issues from the specification.
- User Stories follow INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable)
- Prioritize with MoSCoW (Must/Should/Could/Won't)
- Mark dependencies between issues
- Groom the backlog regularly as the project evolves

## Vertical Slicing

Build the first increment as a walking skeleton: a deployable end-to-end slice that wires every architectural layer together and does almost nothing else.

Grow the system as thin vertical slices — each slice cuts through all layers and delivers one small piece of user value. Slices are tracer bullets: kept and refined, never thrown away.

When a technical unknown blocks a slice, run a spike solution first — a timeboxed, throwaway experiment that removes the risk. Spike code is discarded; only its lesson carries into the slice.

## Implement Next

For each issue:
- Create a feature branch for the EPIC
- Select next issue from backlog (respect dependencies)
- Analyze and document analysis as a comment on the issue
- Implement using TDD (London or Chicago School as appropriate)
- Each test references its Use Case ID for traceability
- Commit with Conventional Commits, reference issue number
- Check if spec or architecture docs need updating
- When EPIC is complete, create a Pull Request

## Refactoring

Refactoring targets are named code smells, not a vague urge to "clean up".

For any refactoring that does not complete in one step, use the Mikado Method: attempt the change, note what breaks, revert, and do the prerequisites first — never leave the build broken while you dig.

Refactoring commits change structure only. Behaviour changes go in separate commits, and the test suite stays green at every commit.

## Code Quality

Our code follows:
- SOLID principles
- DRY, KISS
- Ubiquitous Language from Domain-Driven Design (same terms in code as in the specification)

## Quality Review

Quality assurance follows three layers:
- Code review using Fagan Inspection (structured, systematic, with defined phases)
- Security review based on OWASP Top 10
- Architecture review using ATAM (scenario-based tradeoff analysis against quality goals)
- Use a different AI model or fresh session for reviews to avoid blind spots

## Docs-as-Code

Documentation follows Docs-as-Code according to Ralf D. Müller:
- AsciiDoc as format, PlantUML for inline diagrams, built by docToolchain
- Version-controlled, peer-reviewed, and built automatically
- Plain English according to Strunk & White (or Gutes Deutsch nach Wolf Schneider)
- Projects following this contract include the `dtcw` wrapper and `docToolchainConfig.groovy` so PlantUML / AsciiDoc actually render.

## Socratic Code Theory Recovery

Recover a program's "theory" (Naur 1985) from source code through recursive question refinement.
- Start with 5 high-level questions: Problem/Users, Specification, Architecture, Quality Goals, Risks
- Decompose each question using Semantic Anchors as guides: arc42 (12 sub-questions), Cockburn Use Cases, ISO 25010, Nygard ADRs
- Each leaf is either `[ANSWERED]` (with code evidence) or `[OPEN]` (with Category, Ask role, and why unanswerable)
- The Question Tree is the primary artifact; documentation is synthesized from answered leaves
- Open Questions are the handoff document: routed by role (Product Owner, Architect, Developer, Domain Expert, Operations)
- Two-phase workflow: Phase 1 builds the tree, team answers Open Questions, Phase 2 produces documentation with Q-ID traceability

## Concise Response (TLDR)

Responses lead with the conclusion first (BLUF). Keep to essential points. No filler, no preamble. Use short sentences, active voice, and no unnecessary words (Strunk & White).

## Simple Explanation (ELI5)

Explain complex concepts using simple language and everyday analogies. When the explanation feels hard to write, that reveals gaps in understanding — study those areas first (Feynman Technique).

## Writing Style

Writing follows Gutes Deutsch nach Wolf Schneider (or Plain English according to Strunk & White).

Additionally:
- Technical terms stay in English (LLM, Prompt, Token, Spec, etc.)
- Address the reader directly, use first person sparingly but deliberately
- Use analogies to human thinking to explain technical concepts
- One thought per paragraph (5-8 sentences is fine)
- Section headings are statements, not topic announcements
- First sentence says what the paragraph is about
- Show code and prompts, don't just claim things work
- Conclusions make a clear statement — never end with 'it remains exciting'

---
Generated from https://llm-coding.github.io/Semantic-Anchors/#/contracts
