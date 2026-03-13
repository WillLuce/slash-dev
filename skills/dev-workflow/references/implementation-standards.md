# Implementation Standards

These are the default development standards for `/dev-implement`. They define how code gets written, committed, reviewed, and shipped.

These standards are shipped as sensible defaults. Users can modify this file to match their team's conventions.

---

## The Three-Phase Pattern (Critical)

### Phase 1: DISCUSS (Required Before Any Code)

Before writing ANY code, provide a discussion that explains:

1. **WHAT** are we building?
   - The small, focused change
   - The specific piece we're implementing right now
   - NOT the whole story, just this focused change

2. **WHY** are we building it?
   - Product/feature context
   - How it fits into the larger system
   - What problem it solves

3. **HOW** are we going to build it?
   - Implementation patterns and strategies
   - Specific code concepts that may be unfamiliar
   - Architectural decisions
   - References to similar code in the codebase

**Purpose**: When the developer understands the piece, they can better conceptualize what tests need to be written.

**Format**: Write this as a discussion/explanation, then WAIT for acknowledgment before proceeding.

### Phase 2: PLAN (Required After Discussion)

After discussion is acknowledged, create a step-by-step implementation plan:

```
Here's our implementation plan:

Step 1: [Specific focused action]
Step 2: [Next specific action]
Step 3: [Another specific action]
...

Sound good?
```

**Rules**:
- Each step should be small and focused
- Steps should not span multiple files unnecessarily
- One logical change at a time
- Each step likely results in one or a few commits

**Wait for OK** before proceeding to execution.

### Phase 3: EXECUTE (Step-by-Step)

Execute the plan incrementally:

1. Complete one **complete thought** (code + tests together)
2. Show what was done
3. Commit with thorough conventional commit message
4. Briefly state what's next
5. Move to next thought
6. Don't jump ahead multiple thoughts

---

## Complete Thoughts

### What is a "Complete Thought"?

A conceptually complete unit of work:
- Code + tests together (not separate commits)
- A change + its consequences handled (within reason)
- A concept that is now part of the codebase and can be extended

### Examples

**Adding a new class**:
- Add class scaffolding + tests
- Commit: "Created the concept of [ClassName] in our codebase"

**Implementing a method**:
- Add the method + tests for that method
- Commit: "Added [method] capability to [ClassName]"

**Making a change**:
- Make the change + handle consequences in other methods/tests
- Commit: "Updated [method] to handle [scenario]"

### NOT Complete Thoughts

- Create class (commit), then add tests (separate commit)
- Add method (commit), then add tests (separate commit)
- Change code (commit), then fix broken tests (separate commit)

### Size Guideline

If a change is very large, it contains multiple thoughts. Break it into smaller conceptual units, each independently understandable.

---

## Commit Strategy

**Philosophy**: Commits tell the story of how the PR was built up.

**When to Commit**: After each complete thought is finished.

**Message Format**: [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)

```
type(scope): brief description

[optional body - be thorough and detailed]
Explain what concept was added/changed and why.
Reference patterns and architectural decisions.
```

**Common Types**: feat, fix, docs, test, refactor, chore, ci, perf, style, build

**Example**:
```
feat(approvals): add GenesisApplicationApprovedDTO class

Implements DTO pattern for consuming Genesis approval events.
Uses BigSix filtering to identify academic-admissions events.
Includes unit tests for event parsing and validation.
```

**Context7 Reference**: Use `/websites/conventionalcommits_en_v1_0_0` for the complete specification.

---

## Branch Workflow

**Branch Naming**: `[TICKET-ID]-short-description`
- Example: `CSD-125-project-scaffolding`

**Create branch at start of implementation.**

---

## PR Workflow

**Timing**: Create **early draft PR** to get code visible.

**PR Title Format**: Follow conventional commits:
```
type(scope): brief description
```

**PR Description**:
- Use repository PR template if one exists
- Link to ticket
- Explain WHAT changed and WHY
- Include testing notes

**Merge Strategy**: Squash and merge (one commit per PR in main).

---

## Quality Gates

Before creating/finalizing PR:
- Tests pass locally
- Linting passes
- Code formatted
- Documentation updated (if applicable)
- Branch up-to-date with main
- No debug code or commented-out blocks

---

## Code Change Principles

**Scope**: Small and focused
- Changes should not span multiple files unnecessarily
- One thing at a time
- Keep changes atomic

**File Organization**:
- Keep changes focused
- Don't refactor unrelated code
- Stay on the current step

---

## Testing Approach

**Style**: Mixed / TDD-adjacent
- Understanding the piece helps conceptualize tests
- Tests written as part of understanding the component
- Not strict TDD, but test-aware from the start
- Tests are part of the complete thought

**Test Scope**:
- Unit tests for each new class/method
- Integration tests when connecting components
- Follow existing test patterns in the codebase

---

## Anti-Patterns to Avoid

- Jumping straight to code without discussion
- Large multi-file changes in one step
- Vague commit messages
- Skipping the "why" and "how"
- Batching multiple thoughts before committing
- Working ahead of the plan without discussion
- Force-pushing after reviews start
- Mixing unrelated changes
- Separating code and tests into different commits
