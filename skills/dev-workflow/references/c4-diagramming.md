# C4 Diagramming Reference

C4 is the preferred approach for architecture diagrams. This reference defines conventions for use during `/dev-architecture`.

## Levels

- **Level 1 — System Context**: Shows the system in its environment with users and external systems
- **Level 2 — Container**: Shows the high-level technical building blocks (applications, data stores, etc.)
- **Level 3 — Component**: Shows the internal components of a container

Skip Level 4 (Code) — that level of detail emerges during implementation.

## Context7 Reference

Before discussing diagrams, always fetch C4 documentation:
- Context7 library ID: `/websites/c4model`

## Visual Conventions

- **Light blue fill** = components owned by the system being documented
- **Light gray fill** = external systems outside the boundary
- **Dashed border rectangle** = system boundary
- **Descriptions are context-aware** — describe each component relative to the goal of that specific diagram, not generically
- **Layout for digestibility** — spatial grouping should make relationships clear; not necessarily left-to-right

## Component Presentation Format

When describing components for diagramming, present ONE component or connector at a time:

```
**Title:** <component name>
**Type:** <service type>
**Technology:** *(<technology>)*
**Description:** <what it does in this diagram's context>
**Fill:** Light blue | Light gray

> <Longer contextual explanation for the user — how this piece fits into the
> larger picture, why it exists, what to know about it. Not for the diagram.>
```

Wait for confirmation before moving to the next component. This allows the user to draw each piece in their diagramming tool as the conversation progresses.

## Workflow

1. Discuss which level(s) are appropriate for the current architecture
2. Identify what should be inside vs outside the system boundary
3. Present components one at a time using the format above
4. After all components, discuss connectors/relationships
5. Review the complete diagram together
