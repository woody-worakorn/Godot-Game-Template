# DECISION-001 — VEZQORI Portrait-Only Product Contract

**Status:** Locked Product Owner decision
**Applies to:** VEZQORI phone and tablet product layouts
**Recorded for:** TASK-001 / CORRECTION-001
**Date:** 2026-09-19

## Decision

1. VEZQORI is **portrait-only** on phones and tablets.
2. Landscape product layouts are unsupported unless superseded by a later explicit Product Owner decision.
3. The reference design viewport is **390 × 844** logical pixels.
4. Required portrait validation classes are:
   - Compact phone: **360 × 640**
   - Standard phone: **390 × 844**
   - Tall phone: **430 × 932**
   - Tablet portrait: **768 × 1024**
5. Required project orientation is:

   ```ini
   display/window/handheld/orientation=1
   ```

6. Safe-area handling is mandatory for phone and tablet layouts.
7. Future 3D camera framing, world composition, HUD placement, and touch interactions must preserve portrait composition.
8. Desktop builds may use a portrait-shaped test window; desktop landscape is not a product layout.
9. Physical-device validation on iOS and Android remains required before release.

## Runtime Layout Contract

The foundation shell uses Godot `canvas_items` stretching with an expanding aspect:

```ini
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"
```

This allows the logical content area to use the full available portrait aspect across the required validation classes rather than preserving only the 390 × 844 reference ratio with unused bars.

## Scope Boundary

This decision does not authorize Qori artwork or gameplay, MiniWorld, backend systems, Watch, AR, marketplace, breeding, economy, or Unity work.
