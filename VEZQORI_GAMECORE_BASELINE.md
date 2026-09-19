# VEZQORI GameCore Baseline

## Scope

This file records the accepted, uncustomized Godot Game Template baseline used as VEZQORI GameCore foundation inventory. This acceptance task does not add VEZQORI branding, Qori/MiniWorld content, backend systems, or gameplay integration.

Target project:

`/Volumes/WoodySPACE/Project/VEZQORI/GameCore`

Validation evidence source:

`/Volumes/WoodySPACE/Project/VEZQORI/GameCore/.local-setup-logs/validation-20260919/`

## Repository Identity

- Source repository: `https://github.com/Maaack/Godot-Game-Template`
- Fork repository / clone source: `https://github.com/woody-worakorn/Godot-Game-Template.git`
- GitHub account: `woody-worakorn`
- `origin`: `https://github.com/woody-worakorn/Godot-Game-Template.git`
- `upstream`: `https://github.com/Maaack/Godot-Game-Template.git`
- Active baseline branch: `foundation/vezqori-gamecore`
- Baseline commit: `6849d6c352dafe8ed54b5fa4f4b9774adfca31c8`
- Existing local baseline tag: `vezqori-gamecore-baseline-6849d6c3`
- Baseline divergence from `upstream/main` at acceptance: `0 / 0`

## Godot Runtime

- Executable: `/opt/homebrew/bin/godot`
- Version: `4.7.2.stable.official.ed1daf0bf`
- Project feature declaration: `config/features=PackedStringArray("4.7")`
- Upstream README compatibility statement: `For Godot 4.7 (4.4+ compatible)`
- Compatibility result: **PASS** for Godot 4.7.2 on this Mac baseline.

## Validation Results

| Check | Result | Evidence |
|---|---|---|
| Headless resource import | **PASS** | Exit 0; no parser, script, missing-resource, or dependency error in `import.log`. |
| Raw headless startup | **PASS** | Exit 0; no parser/script/resource error in `headless-raw.log`. |
| Single-threaded headless startup | **PASS** | Exit 0; no parser/script/resource error in `headless-single.log`. |
| Full resource scan | **PASS** | 260 resources checked, 0 failed. |
| Normal GUI launch | **PASS** | Runtime remained alive after launch; GUI log contained no project error/warning. |
| Git source state | **PASS** | Baseline source tree clean before foundation documentation was added. |

### Stale `.godot` cache finding

An earlier validation attempt produced transient parser/resource-load failures. Removing only the generated `.godot` cache and allowing Godot 4.7.2 to rebuild imports resolved the issue. A clean rebuild subsequently passed headless import, raw headless startup, single-threaded startup, resource loading, and normal GUI runtime. No template source file needed to be modified.

This finding should be treated as a generated-cache issue rather than an accepted source defect. If equivalent parser/resource errors recur after switching Godot versions or moving the project, first rebuild `.godot` before changing source.

### Scanner-only shutdown diagnostic

The custom exhaustive resource scanner reported all 260 checked resources as loadable with 0 failures, then emitted Godot shutdown diagnostics about ObjectDB instances/resources remaining in use. Those diagnostics occur in the custom scanner process after successful resource loading and were not present in the normal import, raw headless startup, or normal GUI runtime validation paths. They are recorded as a **scanner/tooling shutdown diagnostic**, not as a baseline project load failure.

## Foundation Manual Flow Acceptance

The acceptance flow used the normal Godot GUI runtime. To honor the task boundary, Godot was launched with a temporary `HOME` inside:

`.local-setup-logs/foundation-acceptance-20260919/sandbox-home`

This kept `user://player_config.cfg` and `user://global_state.tres` inside GameCore rather than modifying the normal macOS user-data directory.

| Step | Result | Evidence / observation |
|---|---|---|
| 1. Boot | **PASS** | Runtime launched normally and remained alive without project error. |
| 2. Main Menu | **PASS** | Main Menu rendered and accepted navigation. Screenshot: `01-main-menu.png`. |
| 3. Options Menu | **PASS** | Options opened and Audio tab was reachable. Screenshot: `02-options.png`. |
| 4. Change harmless setting | **PASS** | Master volume changed one slider step to `0.95`; `player_config.cfg` recorded `Master=0.95`. |
| 5. Return to Main Menu | **PASS** | Options closed back to Main Menu; subsequent New Game action loaded the Example Game. |
| 6. Start Example Game Scene | **PASS** | Actual runtime entered Level 1; save state recorded `current_level_path=res://scenes/game/levels/level_1.tscn` and `total_games_played=1`. Screenshot: `03-example-game.png`. |
| 7. Open Pause Menu | **PASS** | Pause overlay opened in the running Example Game. Screenshot: `04-pause-menu.png`. |
| 8. Resume | **PASS** | Pause closed and gameplay resumed. Additional internal evidence: `resume-check.png`. |
| 9. Return to Main Menu | **PASS** | Revalidated in an isolated normal GUI runtime from the real `game.tscn`: Pause → Main Menu confirmation → Confirm → Main Menu. Screenshot: `05-return-main-menu.png`. |
| 10. Close and relaunch | **PASS** | The GUI runtime was quit with normal macOS `Cmd+Q`, then the project was relaunched with the same acceptance user-data sandbox. |
| 11. Confirm setting persistence | **PASS** | After relaunch, `Master=0.95` remained in `player_config.cfg`; Options/Audio visually matched the changed setting state. Screenshot: `06-relaunch-persistence.png`. |

### Manual-flow warning

The isolated Pause → Main Menu validation run emitted:

`WARNING: Adding 'MainMenuConfirmation' as child to 'PauseMenu' will make owner 'PauseMenu' inconsistent. Consider unsetting the owner beforehand.`

That isolated direct-scene validation run also reported two ObjectDB instances at exit. The full normal project relaunch log was clean. These warnings did not prevent the verified Pause → Main Menu transition, but the owner warning should be tracked during later runtime hardening.

### Screenshot evidence

`.local-setup-logs/foundation-acceptance-20260919/`

- `01-main-menu.png`
- `02-options.png`
- `03-example-game.png`
- `04-pause-menu.png`
- `05-return-main-menu.png`
- `06-relaunch-persistence.png`

All six required images are actual runtime window captures at 1280×784 backing pixels (1280×720 game content plus the captured macOS title-bar area).

## Exact Reproduction Commands

Run from:

`/Volumes/WoodySPACE/Project/VEZQORI/GameCore`

### Verify repository identity

```sh
git status --short --branch
git remote -v
git branch --show-current
git rev-parse HEAD
git fetch upstream --prune
git rev-list --left-right --count HEAD...upstream/main
```

### Verify Godot

```sh
/opt/homebrew/bin/godot --version
grep -n 'config/features' project.godot
grep -n 'For \*Godot 4.7\*' README.md
```

### Clean generated import cache when reproducing baseline validation

```sh
rm -rf .godot
```

This removes generated Godot import/editor cache only. It does not remove tracked source.

### Headless import

```sh
/opt/homebrew/bin/godot --headless --path . --import
```

### Raw headless startup

```sh
/opt/homebrew/bin/godot --headless --path . --quit-after 120
```

### Single-threaded headless startup

```sh
/opt/homebrew/bin/godot --headless --single-threaded-scene --path . --quit-after 120
```

### Full resource scan

The acceptance run used a temporary GDScript scanner at `/tmp/vezqori_gamecore_resource_scan.gd` and executed:

```sh
/opt/homebrew/bin/godot --headless --path . --script /tmp/vezqori_gamecore_resource_scan.gd
```

Acceptance result: `RESOURCE_SCAN checked=260 failed=0`.

### Normal runtime launch

```sh
/opt/homebrew/bin/godot --path .
```

### Acceptance run with isolated `user://` data

```sh
cd /Volumes/WoodySPACE/Project/VEZQORI/GameCore
ACC=.local-setup-logs/foundation-acceptance-20260919
mkdir -p "$ACC/sandbox-home"
HOME="$PWD/$ACC/sandbox-home" /opt/homebrew/bin/godot --path .
```

For the isolated revalidation of Pause → Main Menu from a clean gameplay focus state:

```sh
cd /Volumes/WoodySPACE/Project/VEZQORI/GameCore
ACC=.local-setup-logs/foundation-acceptance-20260919
HOME="$PWD/$ACC/sandbox-home" /opt/homebrew/bin/godot --path . --scene res://scenes/game/game.tscn
```

The manual interaction sequence is recorded in `.local-setup-logs/foundation-acceptance-20260919/MANUAL_FLOW_RESULTS.txt`.

## Evidence Files

- `.local-setup-logs/validation-20260919/VALIDATION_REPORT.txt`
- `.local-setup-logs/validation-20260919/import.log`
- `.local-setup-logs/validation-20260919/headless-raw.log`
- `.local-setup-logs/validation-20260919/headless-single.log`
- `.local-setup-logs/validation-20260919/resource-scan.log`
- `.local-setup-logs/validation-20260919/resource-scan-nocache.log`
- `.local-setup-logs/validation-20260919/gui-launch.log`

## Files Changed by This Acceptance Task

Tracked source/gameplay code remains untouched. The only tracked files added by this acceptance task are:

- `VEZQORI_GAMECORE_BASELINE.md`
- `VEZQORI_FOUNDATION_INVENTORY.md`

Runtime screenshots, validation probes, sandboxed `user://` data, and flow-test logs are stored under `.local-setup-logs/` and are ignored local acceptance evidence. Godot may also refresh generated `.godot/` cache content during validation; no tracked template source is changed by that cache.

## Directories Not Modified

No task changes are permitted or made outside:

`/Volumes/WoodySPACE/Project/VEZQORI/GameCore`

In particular, this task does not modify the parent VEZQORI project's:

- `.ai/`
- `GAME/`
- `UI/`
- `mobile-2.5d/`
- `engine/`
- `contracts/`
- `platform/`
- `infra/`
- `artifacts/`
- `workspaces/`
- `tools/`
- any other sibling directory outside `GameCore`

## Acceptance Boundary

This baseline is an uncustomized foundation template. Passing this baseline does not authorize visual customization, Qori/MiniWorld migration, backend integration, or production gameplay work.
