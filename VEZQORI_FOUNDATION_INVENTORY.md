# VEZQORI GameCore Foundation Inventory

## Purpose

This inventory describes the uncustomized Maaack Godot Game Template foundation at baseline commit:

`6849d6c352dafe8ed54b5fa4f4b9774adfca31c8`

The intent is to decide what may remain as foundation, what needs VEZQORI-specific adaptation later, and what is only example/template content. **Nothing is removed or visually customized by this inventory task.**

Classification meanings:

- **KEEP** — suitable as a foundation capability with no known structural replacement required.
- **KEEP_AND_ADAPT** — useful foundation capability; retain while adapting configuration, UX, data ownership, or presentation for VEZQORI.
- **REPLACE_LATER** — useful for the template/demo, but expected to be superseded for VEZQORI.
- **REMOVE_LATER** — template/example material that should eventually leave the product after equivalent VEZQORI functionality/evidence exists.
- **UNKNOWN** — requires a later product/architecture decision before disposition is safe.

## Summary

| Subsystem | Classification | Foundation finding |
|---|---|---|
| Boot system | **KEEP_AND_ADAPT** | Opening scene/splash flow is usable, but logo/art/timing must later become VEZQORI-specific. |
| Main menu | **KEEP_AND_ADAPT** | Functional New Game/Continue/Options/Credits/Exit shell; presentation and product flow need VEZQORI adaptation. |
| Options/settings | **KEEP_AND_ADAPT** | Persistent input/audio/video/game settings foundation works; mobile-oriented UX must be redesigned. |
| Pause system | **KEEP_AND_ADAPT** | Pause/Resume/Restart/Options/Main Menu/Exit structure is useful; confirmation/focus behavior needs review. |
| Scene loader | **KEEP** | Threaded scene-loading autoload with loading screen, progress, and error paths is broadly reusable. |
| Save system | **KEEP_AND_ADAPT** | Local settings persistence is useful; example gameplay progression/global state should not be treated as final VEZQORI authority. |
| Music controller | **KEEP** | Persistent cross-scene music controller and blending behavior are reusable. |
| Sound controller | **KEEP** | Persistent UI SFX controller for buttons/tabs/sliders/line edits is reusable. |
| Input system | **KEEP_AND_ADAPT** | Keyboard/mouse/gamepad/remapping infrastructure exists; mobile touch product controls are not complete. |
| Credits | **KEEP_AND_ADAPT** | Scroll/end-credit shell is useful; final content and mobile interaction need replacement/adaptation. |
| Loading screen | **KEEP_AND_ADAPT** | Base loading screen plus shader-caching variant are useful; visuals and mobile constraints need VEZQORI treatment. |
| Example game content | **REMOVE_LATER** | Levels/tutorial/demo state are evidence/reference only and are not VEZQORI gameplay. |
| Plugins/autoloads | **KEEP_AND_ADAPT** | Core template, loader, music, and UI sound plugins are useful; editor Plugin Updater should be reviewed before product hardening. |
| Responsive behavior | **KEEP_AND_ADAPT** | Many UI roots use full anchors/containers, but fixed minimums and a 1280×720 baseline remain. |
| Keyboard/mouse assumptions | **REPLACE_LATER** | Demo/tutorial/gameplay assumes desktop controls; VEZQORI mobile-first interaction must supersede these assumptions. |
| Mobile/touch readiness | **KEEP_AND_ADAPT** | Mobile renderer/input primitives exist, but no complete touch control surface was found. |
| Safe-area handling | **KEEP_AND_ADAPT** | No explicit safe-area integration was found; must be added before mobile production UI. |
| Desktop-only behavior | **REPLACE_LATER** | Fullscreen/resolution/Exit/mouse-capture behavior is useful for desktop testing but not final mobile product behavior. |
| External dependencies | **KEEP_AND_ADAPT** | Dependencies are vendored Godot plugins; no backend is introduced. Editor updater can contact source repositories. |
| Attribution/license requirements | **KEEP** | MIT and bundled asset attribution/license obligations must remain tracked through redistribution/customization. |

---

## 1. Boot System — KEEP_AND_ADAPT

### Current implementation

- Project entry scene:
  `res://scenes/opening/opening.tscn`
- Base opening implementation:
  `res://addons/maaacks_game_template/base/nodes/opening/opening.tscn`
- Current opening artwork uses the Godot Engine logo asset.
- The opening flow transitions into the configured main menu through the template/scene-loader path.
- Normal runtime boot validated successfully on Godot 4.7.2.

### VEZQORI disposition

Keep the boot/splash mechanism as foundation. Replace its visual content, timing, branding, and any product-specific startup decisions only in a later authorized visual/product task.

---

## 2. Main Menu — KEEP_AND_ADAPT

### Current implementation

Template base provides:

- New Game
- Options
- Credits
- Exit
- exit confirmation
- keyboard/gamepad focus support

VEZQORI GameCore copy currently extends this with:

- Continue button when a saved current level exists
- optional Level Select support (not currently configured for the baseline)
- New Game confirmation when progress exists
- SceneLoader integration for game transition

Primary scene:

`res://scenes/menus/main_menu/main_menu.tscn`

### Responsive characteristics

The root and major containers use full-rect anchors and layout containers. This is a useful responsive basis, but the template still assumes a desktop-like 1280×720 design baseline and fixed button/window minimum sizes.

### Acceptance observation

Main Menu boot/navigation passed. Pause → Main Menu was revalidated in an isolated normal GUI runtime from the actual Example Game scene and successfully returned to Main Menu after confirmation. The validation path exposed a non-blocking scene-owner warning for `MainMenuConfirmation`, recorded below.

---

## 3. Options / Settings — KEEP_AND_ADAPT

### Current implementation

Main options scene:

`res://scenes/menus/options_menu/master_options_menu_with_tabs.tscn`

Tabs/capabilities:

- Controls / input remapping
- Inputs sensitivity page (present but normally hidden unless enabled)
- Audio
- Video
- Game

The tab container supports `ui_page_up` / `ui_page_down` navigation.

### Persistence

Settings are persisted through:

- `PlayerConfig`
- `user://player_config.cfg`

Sections include:

- `InputSettings`
- `AudioSettings`
- `VideoSettings`
- `GameSettings`
- `ApplicationSettings`
- `CustomSettings`

Acceptance changed Master volume to:

`Master=0.95`

The same value remained after relaunch using an acceptance sandbox under GameCore.

### Audio

Audio controls are dynamically generated from Godot audio buses. The slider baseline is 0.0–1.0 with 0.05 steps.

### Video

Template settings include:

- fullscreen/windowed
- resolution
- V-Sync

These are desktop-relevant and will require mobile product treatment.

---

## 4. Pause System — KEEP_AND_ADAPT

Primary scene:

`res://scenes/windows/pause_menu.tscn`

Capabilities:

- Resume
- Restart
- Options
- Main Menu
- Exit Game
- confirmation dialogs for destructive/navigation actions
- `pauses_game = true`
- SceneLoader integration for main-menu transitions

Pause activation:

`res://addons/maaacks_game_template/base/nodes/utilities/pause_menu_controller.gd`

The controller listens for `ui_cancel`.

### Acceptance observation

Pause opened and Resume returned to active gameplay successfully. Pause → Main Menu confirmation → Confirm → Main Menu also passed when revalidated from a clean isolated normal GUI runtime using the actual `game.tscn` scene. The flow is functionally accepted for this foundation baseline.

---

## 5. Scene Loader — KEEP

Autoload:

`SceneLoader`

Implementation:

`res://addons/maaacks_scene_loader/base/nodes/autoloads/scene_loader/scene_loader.tscn`

Capabilities include:

- threaded resource loading
- load status
- progress reporting
- configured loading screen
- foreground or background loading
- transition to loaded PackedScene
- load/error handling

Configured loading screen:

`res://scenes/loading_screens/loading_screen.tscn`

This subsystem is provider-neutral and is useful independently of VEZQORI content.

---

## 6. Save System — KEEP_AND_ADAPT

There are two distinct persistence concerns.

### A. Player configuration

`PlayerConfig` writes:

`user://player_config.cfg`

This is appropriate for local device/user preferences such as audio, input, and display behavior.

**Disposition:** keep and adapt.

### B. Example/global game state

`GlobalState` writes:

`user://global_state.tres`

The example `GameState` tracks:

- level states
- current level
- checkpoint level
- games played
- play time
- total time

The baseline example flow created state for:

`res://scenes/game/levels/level_1.tscn`

### VEZQORI boundary

The local example progress model is useful as a reference shell only. It must not be assumed to be the final source of truth for VEZQORI identity, genome, online state, progression, or other authoritative product data.

No backend is added in this task.

---

## 7. Music Controller — KEEP

Plugin:

`Maaack's Music Controller 1.7.0`

Autoload:

`ProjectMusicController`

Capabilities include:

- finding autoplay players on the Music bus
- maintaining music across scene transitions
- blending tracks
- internal blend bus handling

This is useful as a generic runtime service.

---

## 8. UI Sound Controller — KEEP

Plugin:

`Maaack's UI Sound Controller 1.7.0`

Autoload:

`ProjectUISoundController`

Capabilities include automatic/persistent UI audio behavior around controls such as:

- Button
- TabBar
- Slider
- LineEdit

Uses an SFX-oriented audio bus.

This is useful as a generic UI foundation.

---

## 9. Input System — KEEP_AND_ADAPT

### Current mappings

The project defines standard UI actions plus example gameplay actions.

UI/navigation:

- `ui_accept`
- `ui_cancel`
- `ui_page_up`
- `ui_page_down`

Example gameplay:

- W/A/S/D movement
- gamepad axes
- Space / gamepad jump
- E / gamepad interact

### Remapping

The template includes input remapping lists/trees, readable names, icons, and gamepad-device handling. Input settings can persist through `PlayerConfig`.

### Touch primitives

`InputEventHelper` recognizes:

- `InputEventScreenTouch`
- `InputEventScreenDrag`

However, inventory search did not find a complete mobile touch control layer or `TouchScreenButton` gameplay control surface in the accepted baseline.

### Disposition

Keep the abstraction/remapping/device-detection foundation. Replace/adapt demo mappings and build dedicated VEZQORI mobile controls later.

---

## 10. Credits — KEEP_AND_ADAPT

Scenes include:

- scrollable credits
- scrolling credits
- end credits
- return-to-main-menu and exit behavior

Current interactions include keyboard axis scrolling and mouse-wheel style assumptions. Final credits content, product navigation, and mobile gesture behavior need later adaptation.

---

## 11. Loading Screen — KEEP_AND_ADAPT

Available scenes include:

- standard loading screen
- level loading screen
- shader-caching loading screen

The technical loading mechanism is reusable. Visual design, progress presentation, mobile loading behavior, and branding are later work.

---

## 12. Example Game Content — REMOVE_LATER

Current template example content includes:

- `scenes/game/game.tscn`
- Level 1
- Level 2
- Level 3
- 2D character example
- 3D character example
- tutorials
- timers
- level manager
- level loader
- win/loss/game-won windows

The example scenes are valuable during foundation validation because they exercise menu → loader → gameplay → pause → state paths.

They are **not VEZQORI gameplay** and should be removed only after replacement functionality/evidence exists in a later authorized task.

No example content is removed in this task.

---

## 13. Plugins and Autoloads — KEEP_AND_ADAPT

### Enabled editor plugins

| Plugin | Version | Classification |
|---|---:|---|
| Maaack's Game Template | 1.7.1 | **KEEP_AND_ADAPT** |
| Maaack's Music Controller | 1.7.0 | **KEEP** |
| Maaack's Scene Loader | 1.7.0 | **KEEP** |
| Maaack's UI Sound Controller | 1.7.0 | **KEEP** |
| Plugin Updater | 0.5.1 | **UNKNOWN** for final production/editor workflow |

### Runtime autoloads

- `SceneLoader`
- `ProjectMusicController`
- `ProjectUISoundController`

### Plugin Updater note

The updater is useful during development but is an editor/dependency-maintenance concern rather than a required product runtime feature. Retain for now and make a deliberate toolchain/security decision later instead of silently removing it.

---

## 14. Responsive Behavior — KEEP_AND_ADAPT

Positive foundation characteristics:

- many root Controls use full anchors
- Margin/Box containers are widely used
- several popup/options shells stretch to the viewport
- compatibility renderer is configured for desktop/mobile

Limitations:

- viewport baseline is explicitly 1280×720
- multiple UI controls/windows have fixed minimum sizes
- menu spacing/font sizing is desktop-template oriented
- no VEZQORI phone/watch visual spec is applied
- no safe-area logic was found

Responsive foundations exist, but production mobile layouts still need dedicated work.

---

## 15. Keyboard / Mouse Assumptions — REPLACE_LATER

The accepted example game and tutorials explicitly teach/use:

- mouse
- keyboard
- gamepad
- right-stick camera control
- mouse capture in the 3D example

These assumptions are suitable for template demonstrations and desktop inspection but are not the intended VEZQORI mobile-first interaction model.

Do not remove them until the replacement mobile interaction path exists and is validated.

---

## 16. Mobile / Touch Readiness — KEEP_AND_ADAPT

Positive signals:

- Godot rendering method has a mobile configuration
- ETC2/ASTC compression import is enabled
- input helper understands screen touch/drag event classes
- responsive Control/container patterns are present

Gaps:

- no complete touch gameplay controller found
- no production mobile gesture/navigation contract
- no mobile-only HUD/control layout
- example gameplay teaches desktop/gamepad interaction
- mobile device acceptance has not been run in this task

Result: foundation is technically adaptable to mobile, but is **not yet mobile UX ready**.

---

## 17. Safe-Area Requirements — KEEP_AND_ADAPT

Inventory search found no explicit implementation using a platform display safe-area API such as `DisplayServer.get_display_safe_area()`.

For mobile production, VEZQORI should add safe-area-aware layout for:

- notches / Dynamic Island areas
- rounded corners
- gesture/home indicators
- tablets with varying insets
- future watch surfaces if they share any UI primitives

No safe-area code is added in this task.

---

## 18. Desktop-Only Behavior — REPLACE_LATER

Desktop-oriented behavior currently includes:

- window resolution choices
- fullscreen settings
- desktop Exit buttons
- mouse capture
- keyboard shortcuts
- mouse-wheel credit interaction
- example FPS/third-person mouse camera control

Some can remain for desktop development builds. They should not define the final mobile experience.

---

## 19. External Dependencies — KEEP_AND_ADAPT

Vendored/template dependencies visible in the project:

- Maaack's Godot Game Template
- Maaack's Scene Loader
- Maaack's Music Controller
- Maaack's UI Sound Controller
- Plugin Updater

No VEZQORI backend, authentication service, cloud provider, analytics provider, or production network system is introduced by this foundation task.

The Plugin Updater has repository/update responsibilities and should be assessed separately for hardened build/editor policy.

---

## 20. Attribution and License Requirements — KEEP

### Godot Game Template

- Author: Marek Belski and contributors
- License: MIT
- Repository: Maaack/Godot-Game-Template
- The copyright notice and MIT permission notice must be included in copies or substantial portions.

### Bundled attribution currently recorded

`ATTRIBUTION.md` also records:

- Godot Engine logo — CC BY 4.0
- Git logo — CC BY 3.0
- Godot Engine — MIT
- Visual Studio Code — MIT (tool reference)
- Git — GPLv2 (tool reference)

When visuals/assets are later removed or replaced, attribution should be reconciled deliberately rather than deleted wholesale.

---

## Foundation Acceptance Issues Before Visual Customization

1. **Non-blocking scene-owner warning:** the isolated actual-runtime Pause → Main Menu acceptance run emitted `Adding 'MainMenuConfirmation' as child to 'PauseMenu' will make owner 'PauseMenu' inconsistent`. The transition still passed. Track this during runtime hardening; it is not a visual-review blocker.
2. **Mobile/touch UX is incomplete.** The foundation has touch event primitives but not a complete VEZQORI mobile interaction layer.
3. **Safe-area handling is absent.** It must be added before production phone/tablet layouts.
4. **Desktop demo assumptions are pervasive in example gameplay.** These should not define the final mobile product direction.
5. **Example save/progression state is not the final VEZQORI authority model.** Keep it as reference only until product architecture opens the appropriate task.
6. **Plugin Updater disposition is unresolved.** Decide whether it remains in the hardened editor workflow later.

No issue found in this acceptance run requires changing the template UI before the requested visual review. The scene-owner warning is technical debt to track separately.

## No-Removal Statement

This task performs inventory and acceptance documentation only. It does not remove, replace, rebrand, relocate, or integrate any runtime subsystem or VEZQORI gameplay content.
