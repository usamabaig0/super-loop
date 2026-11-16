---
name: super-loop
description: "Autonomous pipeline combining Grill-Me, GSD, and Ralph to plan, decompose, and execute software features without manual intervention."
user-invocable: true
---

# Super-loop: Grill-Me + GSD + Ralph

Pipes Grill-Me, GSD, and Ralph together so you can take a feature request from an ambiguous prompt all the way to verified code in one run.

The pipeline links three core tools:
1. Grill-Me questions scope and edge cases before anything gets built.
2. GSD plans file changes, milestones, and acceptance checks.
3. Ralph runs the implementation loop story by story in clean subprocesses.

---

## When to use this

Use `/super-loop [feature description]` or the CLI when you want an agent to take an idea from concept to passing tests without manual hand-holding between steps.

---

## Pipeline stages

### Stage 1: Grill-Me (scoping and edge cases)
1. Deconstructs the prompt to find unstated assumptions:
   - What edge cases need explicit handling?
   - What should stay out of scope?
   - What data migration, security, or performance limits apply?
2. Prompts with 3 to 5 clear design choices and sensible defaults.
3. In autonomous mode, locks the recommended defaults immediately and records the decisions.

### Stage 2: GSD planning
1. Scaffolds `.planning/` if it does not already exist.
2. Creates `.planning/phases/XX-[name]/PLAN.md` with file boundaries, interfaces, and verification requirements.

### Stage 3: Ralph execution loop
1. Compiles the phase plan into `prd.json`:
   - Sizes each story to fit in a single fresh context window.
   - Orders stories strictly by dependency (schemas and contracts first, then core logic, then integration or UI).
   - Specifies concrete acceptance criteria (automated tests, typechecks, or linter rules).
2. Runs the headless execution loop:
   ```bash
   ralph --tool codex 15
   ```
3. In each pass, Ralph:
   - Checks out the feature branch.
   - Implements the next incomplete story in a clean shell session.
   - Runs test suites and commits with `feat: [US-XXX] - [Title]`.
   - Appends notes to `progress.txt` and marks `passes: true`.
   - Repeats until every story passes or max iterations are reached.

### Stage 4: Verification gate
1. Reads git history and `progress.txt` to confirm all stories completed.
2. Runs the project linter, typechecker, and full test suite against the live working tree.
3. Reports final status and points to the branch ready for review.
