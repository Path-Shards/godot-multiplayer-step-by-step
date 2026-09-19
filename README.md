# godot-multiplayer-step-by-step

A multiplayer game for Godot, built **through the editor UI** — every node,
every property and every signal created by clicking through the editor, never
by editing files by hand.

The history is meant to be read. Each step is a small, self-contained change
that can be reproduced in the editor starting from the previous one, so
anyone following along can compare their own progress against the expected
result at any moment.

## How this repository works

- One branch per step, named `<part>-<step>` (for example, `1-2` for Part 1,
  step 2).
- Branches **stack in order**: a branch is created from the previous one,
  never straight from `main` — each adds exactly what that step covers, and
  nothing else.
- `main` only receives the game once the last branch is merged. Until then,
  `main` holds this README alone.
- Every branch is a **validated** state: the project runs and, wherever the
  step covers it, the automated tests for that piece pass.

## Godot version

**4.7.2**, exactly. Using another version may diverge from the screens and
the behaviour shown here.

## Current state

No step branch yet — the structure is still being defined. This README is
updated as the branches come to life.

**Planned parts** (subject to change):

- **Part 0** — Installing Godot 4.7.2
- **Part I** — Fundamentals: a character that walks around a scene
- **Part II** — Basic multiplayer: two instances, synchronized movement
- **Part III** — The complete tag game: role, rule, swap on contact
- **Part IV** — Lobby: discovery, hosting, joining
