# TASK-001 — VEZQORI Foundation Shell v0.1

## Roles

- **PM / Reviewer:** This ChatGPT conversation
- **Worker:** The ChatGPT tab connected to `@WoodyTUBE`
- **Shared control plane:** GitHub Draft Pull Request
- **Local project:** `/Volumes/WoodySPACE/Project/VEZQORI/GameCore`
- **Repository:** `woody-worakorn/Godot-Game-Template`
- **Working branch:** `feature/vezqori-foundation-shell`
- **Base branch:** `foundation/vezqori-gamecore`
- **Frozen baseline commit:** `ed9e58f3f19295083bc52e8c1f7ccac8d06c8273`
- **Frozen baseline tag:** `vezqori-gamecore-baseline-20260919`
- **Godot:** `4.7.2.stable.official.ed1daf0bf`

## Mission

Transform the validated generic Maaack template into the first visible, mobile-first VEZQORI application shell while preserving the working foundation systems.

This task must create a visibly reviewable runtime. Parser success or documentation alone is not enough.

## Product direction

VEZQORI is a creature-raising life game. This task is only the application shell; do not add Qori gameplay yet.

Visual direction:

- Midnight navy base
- Luminous teal
- Soft aqua
- Violet accent
- Warm cream
- Cozy, mysterious, premium, soft-futuristic
- Mobile-first and touch-first
- No pixel-art styling
- No generic sci-fi dashboard clutter
- Use existing VEZQORI visual references read-only when available

## Preflight

Before editing:

1. Activate `/Volumes/WoodySPACE/Project/VEZQORI`.
2. Read project instructions and routing documents.
3. Enter `/Volumes/WoodySPACE/Project/VEZQORI/GameCore`.
4. Confirm branch is `feature/vezqori-foundation-shell`.
5. Confirm HEAD descends from `ed9e58f3f19295083bc52e8c1f7ccac8d06c8273`.
6. Confirm the working tree is clean.
7. Read:
   - `VEZQORI_GAMECORE_BASELINE.md`
   - `VEZQORI_FOUNDATION_INVENTORY.md`
8. Inspect actual baseline screenshots under:
   - `.local-setup-logs/foundation-acceptance-20260919/`
9. Push the working branch to `origin` if it is not already present.
10. Open a **Draft Pull Request**:
    - Title: `[TASK-001] VEZQORI Foundation Shell v0.1`
    - Base: `foundation/vezqori-gamecore`
    - Head: `feature/vezqori-foundation-shell`
11. Post a PR comment beginning with `STARTED` containing:
    - branch
    - HEAD
    - Godot version
    - clean/dirty status
    - intended file scope
    - implementation plan

## Scope A — Preserve foundation behavior

Keep these working:

- Boot flow
- Main-menu routing
- Options/settings persistence
- Audio buses and master-volume persistence
- Scene loading/transitions
- Pause and resume
- Return to main menu
- Credits routing

Do not rewrite working systems without a demonstrated need.

## Scope B — Reusable responsive mobile root

Implement a reusable application root using Godot `Control` nodes and container-based layout.

Requirements:

- Do not hardcode the whole interface to one resolution.
- Use anchors, containers, size flags and sensible minimum sizes.
- Add a clear safe-area layer/adapter for mobile cutouts and system bars.
- Avoid absolute positioning except for deliberate decorative elements.
- Support mouse for desktop development.
- Use touch-friendly interactive targets.
- Separate layout tokens from individual screen implementation.

Validation viewport classes:

- Compact phone: `360 × 640`
- Standard phone: `390 × 844`
- Tall phone: `430 × 932`
- Tablet portrait: `768 × 1024`

These are validation cases, not a permanent fixed game resolution.

## Scope C — VEZQORI Welcome screen

Replace the generic main-menu presentation while preserving its routing and settings behavior.

Visible actions:

- `Continue Journey`
- `Begin Journey`
- `Settings`
- `Credits`

Platform behavior:

- Do not show a prominent Quit action on mobile.
- Desktop quit may remain through an unobtrusive, platform-aware route.

For this task, Continue and Begin Journey may both load the Home Shell placeholder, but their routing must remain distinct and documented.

## Scope D — Home Shell placeholder

Create a non-gameplay placeholder representing the future VEZQORI Home.

It must include:

- Top header/status region
- Main world/content placeholder region
- Bottom navigation:
  - Home
  - Qori
  - Journey
  - Collection
  - Profile
- Active-tab state
- Touch-friendly targets
- Clear `MOCK / PLACEHOLDER` marker

Bottom navigation must switch between lightweight local placeholder panels without backend data.

## Scope E — Settings

- Preserve real master-volume persistence.
- Keep settings useful for mobile.
- Hide or isolate desktop-only settings appropriately.
- Ensure long content scrolls on compact screens.
- Preserve Back/Return behavior.
- Do not break desktop testability.

## Scope F — Credits and attribution

- Preserve Maaack/Godot attribution and license obligations.
- Add a VEZQORI project heading.
- Do not remove required upstream attribution.

## Architecture constraints

Use this boundary:

```text
Existing foundation logic
        ↓
VEZQORI presentation shell
        ↓
Mock/local shell state
```

Prefer wrapping/extending template behavior instead of editing third-party addon internals.

If an upstream/addon file must be modified, document exactly why and list it in the report.

## Explicitly out of scope

Do not add or migrate:

- Qori artwork or Qori gameplay
- MiniWorld
- Care
- Personality
- Genome
- Authentication
- Supabase/PostgreSQL
- Nakama
- Multiplayer or online friends
- Marketplace
- Breeding
- Watch/HealthKit/Health Connect
- AR
- AI companion backend
- AI Morph Foundry
- Qori Forge
- Production economy
- Unity work

Do not modify anything outside `GameCore`. Reading existing VEZQORI instructions and visual references outside GameCore is allowed; writing is not.

## Required execution loop

Work autonomously:

1. Inspect
2. Plan the smallest coherent change
3. Implement
4. Run parser/import validation
5. Run headless startup
6. Run normal GUI runtime
7. Manually test affected flows
8. Capture screenshots
9. Fix defects
10. Repeat until acceptance passes or a genuine blocker is proven

Do not mark PASS after parser success alone.

## Manual validation flow

Verify in actual runtime:

1. Boot
2. VEZQORI Welcome appears
3. Open Settings
4. Change Master Volume
5. Return to Welcome
6. Open Credits and return
7. Select Begin Journey
8. Home Shell loads
9. Switch through all five bottom tabs
10. Open Pause where supported
11. Resume
12. Return to Welcome
13. Close and relaunch
14. Confirm Master Volume persists
15. Confirm layout remains usable in all four viewport classes

## Acceptance criteria

PASS requires all:

- Runtime visibly looks like an initial VEZQORI shell, not the generic template.
- Existing navigation and setting persistence still work.
- No parser errors.
- No script errors.
- No missing resources.
- Headless startup succeeds.
- GUI runtime launches successfully.
- Welcome, Settings, Credits and Home Shell routes work.
- All five bottom tabs work.
- Compact phone content is not clipped and remains navigable.
- Tall phone layout has no broken anchoring.
- Tablet layout remains coherent rather than simply stretched.
- Interactive controls are touch-friendly.
- Required attribution remains.
- No files outside GameCore changed.

## Evidence

Create:

`.local-setup-logs/task-001-foundation-shell/`

Minimum evidence:

- `01-welcome-compact.png`
- `02-welcome-standard.png`
- `03-welcome-tall.png`
- `04-welcome-tablet.png`
- `05-settings.png`
- `06-credits.png`
- `07-home-shell.png`
- `08-bottom-nav-qori.png`
- `09-bottom-nav-journey.png`
- `10-pause.png`
- `11-relaunch-persistence.png`
- import log
- headless log
- GUI/runtime log
- manual-flow results

Create:

`VEZQORI_FOUNDATION_SHELL_V0_1.md`

The report must include:

- files changed
- upstream/addon files modified, if any
- architecture
- mock vs real behavior
- viewport results
- manual-flow results
- persistence result
- warnings/errors
- unresolved limitations
- exact validation commands
- final commit SHA

## Git discipline

- Work only on `feature/vezqori-foundation-shell`.
- Use small coherent commits.
- Push after meaningful gates.
- Do not force-push frozen baseline references.
- Do not merge to the base branch or `main`.

## Worker reporting protocol

Use the Draft PR conversation:

1. `STARTED` — preflight and plan
2. `IMPLEMENTED` — visible changes and commit SHAs
3. `VALIDATED` — automated + manual test results and evidence paths
4. `FINAL` — final SHA, PASS/PARTIAL/FAILED, blockers and limitations

If tests fail, continue fixing before `FINAL` unless a genuine external blocker is proven.

## PM review protocol

The PM will:

1. Inspect PR metadata and commits.
2. Review changed files and screenshots/reports.
3. Compare behavior against acceptance criteria.
4. Approve, comment, or request changes.
5. Issue a bounded correction task.
6. Re-review after the worker pushes fixes.
7. Never merge without explicit owner approval.

## Stop condition

After pushing the validated branch and posting `FINAL`, stop.

Do not integrate Qori or MiniWorld. Do not merge the PR.
