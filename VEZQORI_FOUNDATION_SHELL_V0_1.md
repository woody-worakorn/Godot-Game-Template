# VEZQORI Foundation Shell v0.1 — TASK-001 Final Report

**Acceptance status after CORRECTION-001:** PASS
**Project:** `/Volumes/WoodySPACE/Project/VEZQORI/GameCore`
**Working branch:** `feature/vezqori-foundation-shell`
**Base branch:** `foundation/vezqori-gamecore`
**Frozen baseline:** `ed9e58f3f19295083bc52e8c1f7ccac8d06c8273`
**Reviewed pre-correction PR head:** `d3aa5afda0c1e302b13deb4d1dfd76f9b6bd375d`
**Final validated correction runtime/config commit:** `db4f99a63bfb962c92b483c9c4e54f6bf64d8040`
**Godot:** `4.7.2.stable.official.ed1daf0bf`

The SHA above is the commit that changes the runtime portrait contract. This report and the curated review evidence are committed afterward as documentation/evidence only; the Draft PR correction comment records the resulting branch head SHA.

## 1. Mission Result

TASK-001 transforms the validated generic Maaack template into an initial VEZQORI mobile application shell while preserving the accepted Godot foundation systems.

CORRECTION-001 additionally locks and validates the Product Owner decision that VEZQORI is **portrait-only on phones and tablets**.

Delivered visible routes:

- VEZQORI Welcome
- Mobile-useful Settings
- Credits and upstream attribution
- Local/mock Home Shell
- Home, Qori, Journey, Collection, and Profile placeholder tabs
- VEZQORI Pause overlay
- Return-to-Welcome confirmation

No Qori artwork/gameplay, MiniWorld, backend, Watch, AR, marketplace, breeding, economy, or Unity content was introduced.

## 2. Locked Portrait-Only Product Contract

The tracked product decision is:

`PM_TASKS/DECISION-001_VEZQORI_PORTRAIT_ONLY.md`

The contract establishes:

1. Phone and tablet product layouts are portrait-only.
2. Landscape product layouts are unsupported unless a later explicit Product Owner decision supersedes this contract.
3. Reference viewport: `390 × 844`.
4. Required portrait validation classes:
   - `360 × 640`
   - `390 × 844`
   - `430 × 932`
   - `768 × 1024`
5. Required handheld orientation: `display/window/handheld/orientation=1`.
6. Safe-area handling is mandatory.
7. Future camera, world, HUD, and touch composition must preserve portrait framing.
8. Desktop may use a portrait-shaped test window, but desktop landscape is not a product layout.
9. Physical iOS/Android validation remains required before release.

The runtime stretch contract is now:

```ini
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"
window/handheld/orientation=1
```

`expand` allows the logical canvas to expand to each available portrait ratio instead of retaining only the 390 × 844 ratio and producing unused bands.

## 3. Architecture

The implementation preserves this boundary:

```text
Existing foundation logic
        ↓
VEZQORI presentation shell
        ↓
Mock/local shell state
```

### Existing foundation logic retained

- `MaaacksGameTemplate` base behavior and routing helpers
- `SceneLoader` autoload and loading-screen path
- `PlayerConfig` / `AppSettings` persistence
- Music controller autoload
- UI sound controller autoload
- Pause/resume and return-to-menu foundation behavior
- Existing opening/startup path
- Existing MIT/license and attribution files

### Project-owned presentation shell

- Semantic color, spacing, touch-size, and component tokens in `scripts/vezqori/ui_tokens.gd`
- Project-owned UI component factory in `scripts/vezqori/ui_factory.gd`
- Safe-area and responsive margin adapter in `scripts/vezqori/safe_area_root.gd`
- Ambient VEZQORI backdrop in `scripts/vezqori/ambient_backdrop.gd`
- Welcome, Settings, Credits, Home, and Pause wrappers under `scenes/vezqori/` and `scripts/vezqori/`

### Mock/local shell state

`scripts/vezqori/shell_state.gd` stores process-local presentation state only:

- `entry_route`: `begin` or `continue`
- active bottom tab

It does not create gameplay progression, accounts, backend state, cloud data, economy, or authoritative VEZQORI data.

## 4. Real vs Mock Behavior

| Capability | Classification | Result |
|---|---|---|
| Boot → Welcome | Real foundation behavior | Preserved through the existing opening and SceneLoader path. |
| Continue Journey | Real local navigation | Loads Home and identifies `CONTINUE ROUTE • LOCAL`. |
| Begin Journey | Real local navigation | Loads Home and identifies `BEGIN ROUTE • LOCAL`. |
| Settings navigation | Real | Welcome and Pause can open Settings. |
| Master volume | Real | Changes the AudioServer Master bus and persists through `PlayerConfig`. |
| Mute | Real | Changes Master mute and persists through `PlayerConfig`. |
| Credits | Real presentation/legal route | VEZQORI heading plus Maaack/Godot/MIT attribution retained. |
| Pause / Resume | Real foundation behavior | Preserved and visually wrapped. |
| Return to Welcome | Real foundation navigation | Confirmation and SceneLoader route pass. |
| Portrait `expand` | Real project behavior | Effective logical canvas follows each portrait output ratio. |
| Safe-area adapter | Real layout behavior | Base padding plus `DisplayServer.get_display_safe_area()` on mobile. |
| Home/Qori/Journey/Collection/Profile content | Mock/local | Interactive placeholder tabs only. |
| Qori creature/gameplay data | Not implemented | Explicitly out of scope. |
| Backend/account/cloud sync | Not implemented | Explicitly out of scope. |

## 5. Files Changed

TASK-001 implementation and correction-owned tracked files include:

```text
PM_TASKS/TASK-001_VEZQORI_FOUNDATION_SHELL.md
PM_TASKS/DECISION-001_VEZQORI_PORTRAIT_ONLY.md
project.godot
scenes/vezqori/credits/credits_screen.tscn
scenes/vezqori/home/home_shell.tscn
scenes/vezqori/pause/pause_menu.tscn
scenes/vezqori/settings/settings_screen.tscn
scenes/vezqori/welcome/welcome.tscn
scripts/vezqori/ambient_backdrop.gd
scripts/vezqori/credits_screen.gd
scripts/vezqori/home_shell.gd
scripts/vezqori/pause_shell.gd
scripts/vezqori/safe_area_root.gd
scripts/vezqori/settings_screen.gd
scripts/vezqori/shell_state.gd
scripts/vezqori/ui_factory.gd
scripts/vezqori/ui_tokens.gd
scripts/vezqori/welcome_screen.gd
artifacts/review/task-001-foundation-shell/README.md
artifacts/review/task-001-foundation-shell/01-welcome-compact.png
artifacts/review/task-001-foundation-shell/02-welcome-standard.png
artifacts/review/task-001-foundation-shell/03-welcome-tall.png
artifacts/review/task-001-foundation-shell/04-welcome-tablet.png
artifacts/review/task-001-foundation-shell/05-settings-standard.png
artifacts/review/task-001-foundation-shell/06-home-standard.png
artifacts/review/task-001-foundation-shell/07-pause-standard.png
VEZQORI_FOUNDATION_SHELL_V0_1.md
```

Godot-generated `.uid` companions for the project-owned scripts are also tracked.

### Upstream/addon files modified

**None.**

Audit result:

- addon diff count: `0`
- no file outside GameCore was modified
- the only existing runtime/config file modified is `project.godot`

## 6. Portrait `expand`, Safe-Area, and No-Bars Results

The four actual GUI viewport classes passed a deterministic layout-contract probe after a clean import.

| Physical game-content viewport | Effective logical canvas | Aspect result | Layout result |
|---:|---:|---|---|
| 360 × 640 | 474 × 844 | Ratio delta `0.0008886` | PASS — expanded logical width, actions reachable, compact pause in bounds |
| 390 × 844 | 390 × 844 | Ratio delta `0` | PASS — reference viewport |
| 430 × 932 | 390 × 845 | Ratio delta `0.0001651` | PASS — tall logical height expands without broken anchoring |
| 768 × 1024 | 633 × 844 | Ratio delta `0` | PASS — expanded logical width with bounded content |

### Safe-area results

| Class | Safe-area logical rect | Base margins | Result |
|---|---:|---:|---|
| Compact | 474 × 844 | 20 each side | PASS |
| Standard | 390 × 844 | 20 each side | PASS |
| Tall | 390 × 845 | 20 each side | PASS |
| Tablet | 633 × 844 | 32 left/right, 20 top/bottom | PASS |

All Welcome actions remained visible and inside the effective logical viewport.

### Bottom navigation

At every viewport:

- Home visible/touchable
- Qori visible/touchable
- Journey visible/touchable
- Collection visible/touchable
- Profile visible/touchable
- each tab remained inside the effective logical viewport
- each tab had at least a 48-pixel logical height

### Compact Settings and Pause

At 360 × 640:

- Settings vertical scrolling passed; scroll position changed and the bottom `MOCK / LOCAL ONLY` marker became reachable.
- Pause rendered at logical `320 × 348`, remained fully inside the effective `474 × 844` logical canvas, and exposed Resume, Settings, and Return to Welcome.

### Tablet bounding

At 768 × 1024:

- effective logical canvas: `633 × 844`
- main content width: `569`
- logical left/right gap: `32` / `32`
- result: centered and bounded rather than stretched edge-to-edge

### Letterbox / pillarbox result

The seven committed actual-runtime PNGs were analyzed at all four outer edges.

- exact-black edge ratio: `0.0`
- near-black edge ratio: `0.0`
- result: **PASS — no unintended letterbox or pillarbox band detected**

## 7. Manual Flow Result

The full flow was rerun in a normal 390 × 844 GUI runtime with an isolated `HOME` under `.local-setup-logs/correction-001-portrait/`.

| Step | Result |
|---|---|
| Boot normal project | PASS |
| VEZQORI Welcome appears | PASS |
| Open Settings | PASS |
| Change Master volume | PASS (`1.0` → `0.85`) |
| Mute restored to Off | PASS |
| Return to Welcome | PASS |
| Open Credits | PASS |
| Maaack/Godot/MIT attribution visible | PASS |
| Return from Credits | PASS |
| Select Begin Journey | PASS |
| Home Shell loads | PASS (`BEGIN ROUTE • LOCAL`) |
| Home tab | PASS |
| Qori tab | PASS |
| Journey tab | PASS |
| Collection tab | PASS |
| Profile tab | PASS |
| Open Pause | PASS |
| Open Settings from Pause and Back | PASS |
| Resume | PASS |
| Return confirmation | PASS (`Stay` / `Return`) |
| Return to Welcome | PASS |
| Native Cmd-Q exit | PASS |
| Relaunch same user-data sandbox | PASS |
| Master volume persists | PASS (`Master=0.85`, UI `85%`) |

Detailed ignored runtime evidence:

`.local-setup-logs/correction-001-portrait/manual-flow-results.md`

## 8. Persistence Result

Correction acceptance user data was isolated at:

`.local-setup-logs/correction-001-portrait/manual/home/Library/Application Support/Godot/app_userdata/VEZQORI/player_config.cfg`

Persisted result after quit and relaunch:

```ini
[AudioSettings]
Mute=false
Master=0.85
```

The relaunched Settings screen displayed `85%` and `Mute all audio: Off`.

## 9. PM-Reviewable Screenshot Evidence

Tracked review root:

`artifacts/review/task-001-foundation-shell/`

| File | Exact game-content size | Purpose |
|---|---:|---|
| `01-welcome-compact.png` | 360 × 640 | Compact portrait Welcome |
| `02-welcome-standard.png` | 390 × 844 | Reference portrait Welcome |
| `03-welcome-tall.png` | 430 × 932 | Tall portrait Welcome |
| `04-welcome-tablet.png` | 768 × 1024 | Tablet portrait Welcome |
| `05-settings-standard.png` | 390 × 844 | Real persistent Settings state |
| `06-home-standard.png` | 390 × 844 | Home and five-tab navigation |
| `07-pause-standard.png` | 390 × 844 | Pause overlay |

These are actual Godot runtime window captures. The macOS title bar is excluded. Full provenance, dimensions, limitations, gallery links, and SHA-256 values are in:

`artifacts/review/task-001-foundation-shell/README.md`

Full logs and uncurated diagnostics remain ignored under:

`.local-setup-logs/correction-001-portrait/`

## 10. Automated Validation Results

| Gate | Result |
|---|---|
| Clean `.godot` import | PASS — exit 0; 0 parser/resource errors; 0 warnings |
| Raw headless startup | PASS — exit 0; 0 parser/script/resource errors |
| Scene matrix | PASS — Welcome, Settings, Credits, Home: 0 errors / 0 warnings |
| Full resource scan | PASS — 275 checked / 0 failed |
| Normal GUI boot | PASS — no live errors or warnings before exit |
| Four actual-GUI portrait contract probes | PASS — 0 failures for every class |
| No-bars image analysis | PASS — all seven curated captures |
| Complete actual-runtime manual flow | PASS |
| Volume persistence | PASS |
| Compact Settings scroll | PASS |
| Compact Pause bounds | PASS |
| Five-tab visibility/touchability | PASS at all classes |
| Tablet centered/bounded composition | PASS |
| Addon modification audit | PASS — 0 addon files modified |

Correction logs:

- `.local-setup-logs/correction-001-portrait/final-validation/import.log`
- `.local-setup-logs/correction-001-portrait/final-validation/headless-main.log`
- `.local-setup-logs/correction-001-portrait/final-validation/scene-matrix.txt`
- `.local-setup-logs/correction-001-portrait/final-validation/resource-scan.log`
- `.local-setup-logs/correction-001-portrait/final-validation/viewport-contract-summary.txt`
- `.local-setup-logs/correction-001-portrait/final-validation/curated-edge-analysis.json`
- `.local-setup-logs/correction-001-portrait/final-validation/gui-normal.log`
- `.local-setup-logs/correction-001-portrait/manual/gui-flow.log`
- `.local-setup-logs/correction-001-portrait/manual/gui-relaunch.log`

## 11. Warnings / Errors

### Live parser, script, missing-resource, GUI, and navigation errors

**None in the final correction validation.**

### Shutdown-only ObjectDB diagnostics

Godot 4.7.2 reported anonymous shutdown-only diagnostics after otherwise successful processes:

- raw forced headless `--quit-after`: 4 ObjectDB instances
- full manual flow normal quit: 6 ObjectDB instances
- final normal Welcome GUI quit: 4 ObjectDB instances

No parser, script, missing-resource, route, visual, or interaction failure occurred before shutdown.

### Scanner-only cleanup diagnostics

The exhaustive scanner first reported:

`RESOURCE_SCAN checked=275 failed=0`

Its cleanup then reported:

- 21 ObjectDB instances
- 10 resources still in use

These occur after intentionally loading the entire resource graph in one scanner process. They are not hidden and are distinct from live runtime failures.

## 12. Unresolved Limitations

Non-blocking limitations retained for PM review:

1. No iOS/Android export or physical-device notch/safe-area test was performed; physical-device validation remains required before release.
2. Home, Qori, Journey, Collection, and Profile content remains explicitly local/mock placeholder content.
3. The preserved opening sequence still uses the existing foundation Godot splash before VEZQORI Welcome.
4. Final licensed VEZQORI typography has not been supplied; the shell uses project/system typography.
5. Desktop Quit remains unobtrusive/hidden at phone and tablet widths; desktop developers retain native Cmd-Q.
6. Shutdown-only diagnostics remain as documented above.
7. No Qori, MiniWorld, backend, Watch, AR, marketplace, breeding, or economy integration exists.

No limitation above blocks PM visual review of Foundation Shell v0.1.

## 13. Exact Validation Commands

Run from:

`/Volumes/WoodySPACE/Project/VEZQORI/GameCore`

### Identity and portrait settings

```sh
git branch --show-current
git rev-parse HEAD
git status --short --branch
grep -n -A10 -B2 '^\[display\]' project.godot
```

### Clean import

```sh
rm -rf .godot
/opt/homebrew/bin/godot --headless --path . --import
```

### Raw headless startup

```sh
/opt/homebrew/bin/godot --headless --path . --quit-after 120
```

### Scene matrix

```sh
/opt/homebrew/bin/godot --headless --path . --scene res://scenes/vezqori/welcome/welcome.tscn --quit-after 120
/opt/homebrew/bin/godot --headless --path . --scene res://scenes/vezqori/settings/settings_screen.tscn --quit-after 120
/opt/homebrew/bin/godot --headless --path . --scene res://scenes/vezqori/credits/credits_screen.tscn --quit-after 120
/opt/homebrew/bin/godot --headless --path . --scene res://scenes/vezqori/home/home_shell.tscn --quit-after 120
```

### Full resource scan

```sh
/opt/homebrew/bin/godot --headless --path . \
  --script "$PWD/.local-setup-logs/correction-001-portrait/final-validation/resource_scan.gd"
```

### Four actual-GUI portrait classes

```sh
/opt/homebrew/bin/godot --windowed --screen 0 --resolution 360x640 --path . --scene res://scenes/vezqori/welcome/welcome.tscn
/opt/homebrew/bin/godot --windowed --screen 0 --resolution 390x844 --path . --scene res://scenes/vezqori/welcome/welcome.tscn
/opt/homebrew/bin/godot --windowed --screen 0 --resolution 430x932 --path . --scene res://scenes/vezqori/welcome/welcome.tscn
/opt/homebrew/bin/godot --windowed --screen 0 --resolution 768x1024 --path . --scene res://scenes/vezqori/welcome/welcome.tscn
```

### Automated GUI layout contract at each portrait class

```sh
HOME="$PWD/.local-setup-logs/correction-001-portrait/final-validation/home-360x640" \
  /opt/homebrew/bin/godot --windowed --screen 0 --resolution 360x640 --path . \
  --script "$PWD/.local-setup-logs/correction-001-portrait/layout_contract_probe.gd"
```

The same command was repeated for `390x844`, `430x932`, and `768x1024`.

### Normal full-project manual/persistence run

```sh
ACC=.local-setup-logs/correction-001-portrait
HOME="$PWD/$ACC/manual/home" \
  /opt/homebrew/bin/godot --windowed --screen 0 --resolution 390x844 --path .
```

### Curated no-bars analysis

```sh
python3 .local-setup-logs/correction-001-portrait/helpers/edge_analysis.py \
  artifacts/review/task-001-foundation-shell/01-welcome-compact.png \
  artifacts/review/task-001-foundation-shell/02-welcome-standard.png \
  artifacts/review/task-001-foundation-shell/03-welcome-tall.png \
  artifacts/review/task-001-foundation-shell/04-welcome-tablet.png \
  artifacts/review/task-001-foundation-shell/05-settings-standard.png \
  artifacts/review/task-001-foundation-shell/06-home-standard.png \
  artifacts/review/task-001-foundation-shell/07-pause-standard.png
```

## 14. Git / PR State

- Draft PR: `woody-worakorn/Godot-Game-Template#1`
- Task packet commit: `3e70f477c799f82b2dd58d92ff5a2d39c624122c`
- Main implementation commit: `3fd7f1b45ea706db1d055905490af59fede498c9`
- Pause/mobile navigation fix: `bccfa7de797bb1625d7f920ca46739c23cfc9b37`
- Original TASK-001 report commit: `d3aa5afda0c1e302b13deb4d1dfd76f9b6bd375d`
- CORRECTION-001 portrait runtime/config commit: `db4f99a63bfb962c92b483c9c4e54f6bf64d8040`
- Branch remains `feature/vezqori-foundation-shell`.
- PR remains Draft.
- No merge performed.
