extends MainMenu

const SETTINGS_SCENE := preload("res://scenes/vezqori/settings/settings_screen.tscn")
const CREDITS_SCENE := preload("res://scenes/vezqori/credits/credits_screen.tscn")
const CONFIRMATION_SCENE := preload("res://addons/maaacks_game_template/base/nodes/windows/confirmation_popup_window_panel.tscn")
const CAPTURE_FOCUS_SCRIPT := preload("res://addons/maaacks_game_template/base/nodes/utilities/capture_focus.gd")

var _content_column: VBoxContainer
var _welcome_scroll: ScrollContainer
var _continue_button: Button
var _desktop_exit_button: Button
var _wordmark: Label
var _hero_panel: PanelContainer
var _route_note: Label

func _enter_tree() -> void:
	theme = VezqoriUITokens.make_theme()
	options_packed_scene = SETTINGS_SCENE
	credits_packed_scene = CREDITS_SCENE
	_build_ui()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var backdrop := VezqoriAmbientBackdrop.new()
	add_child(backdrop)

	var safe_area := VezqoriSafeAreaRoot.new()
	safe_area.name = "SafeAreaRoot"
	add_child(safe_area)

	var shell := VBoxContainer.new()
	shell.name = "WelcomeShell"
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	safe_area.add_child(shell)

	var header := HBoxContainer.new()
	header.custom_minimum_size.y = 48.0
	shell.add_child(header)

	var micro_brand := VezqoriUIFactory.label("VEZQORI", &"section")
	micro_brand.add_theme_font_size_override(&"font_size", 15)
	header.add_child(micro_brand)
	header.add_child(VezqoriUIFactory.expanding_spacer())

	var foundation_badge := VezqoriUIFactory.badge("FOUNDATION SHELL  v0.1")
	header.add_child(foundation_badge)

	_desktop_exit_button = VezqoriUIFactory.button("Quit", &"ghost", true)
	_desktop_exit_button.name = "ExitButton"
	_desktop_exit_button.unique_name_in_owner = true
	_desktop_exit_button.tooltip_text = "Quit VEZQORI on desktop"
	header.add_child(_desktop_exit_button)
	_desktop_exit_button.owner = self

	_welcome_scroll = ScrollContainer.new()
	_welcome_scroll.name = "WelcomeScroll"
	_welcome_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_welcome_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_welcome_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_welcome_scroll.follow_focus = true
	shell.add_child(_welcome_scroll)

	var body_center := CenterContainer.new()
	body_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_welcome_scroll.add_child(body_center)

	_content_column = VBoxContainer.new()
	_content_column.name = "WelcomeContent"
	_content_column.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_content_column.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	body_center.add_child(_content_column)

	_wordmark = VezqoriUIFactory.label("VEZQORI", &"brand")
	_wordmark.name = "Wordmark"
	_wordmark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content_column.add_child(_wordmark)

	var tagline := VezqoriUIFactory.label("A quiet world is waiting to remember you.", &"hero")
	tagline.name = "WelcomeTagline"
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tagline.add_theme_font_size_override(&"font_size", 24)
	_content_column.add_child(tagline)

	var supporting := VezqoriUIFactory.label(
		"Begin with a lightweight local shell. Your creature, world and connected systems arrive in later phases.",
		&"body"
	)
	supporting.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content_column.add_child(supporting)

	_hero_panel = VezqoriUIFactory.panel(&"glass")
	_hero_panel.custom_minimum_size.y = 96.0
	_content_column.add_child(_hero_panel)
	var hero_box := VBoxContainer.new()
	hero_box.alignment = BoxContainer.ALIGNMENT_CENTER
	hero_box.add_theme_constant_override(&"separation", 4)
	_hero_panel.add_child(hero_box)
	var hero_mark := VezqoriUIFactory.label("◌", &"brand")
	hero_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_mark.add_theme_font_size_override(&"font_size", 38)
	hero_box.add_child(hero_mark)
	var hero_copy := VezqoriUIFactory.label("LOCAL MOCK  •  NO GAMEPLAY DATA", &"badge")
	hero_copy.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_box.add_child(hero_copy)

	var menu_box := VBoxContainer.new()
	menu_box.name = "MenuButtonsBoxContainer"
	menu_box.unique_name_in_owner = true
	menu_box.set_script(CAPTURE_FOCUS_SCRIPT)
	menu_box.set("search_depth", 2)
	menu_box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	_content_column.add_child(menu_box)
	menu_box.owner = self

	_continue_button = VezqoriUIFactory.button("Continue Journey", &"primary")
	_continue_button.name = "ContinueGameButton"
	_continue_button.unique_name_in_owner = true
	menu_box.add_child(_continue_button)
	_continue_button.owner = self

	var begin_button := VezqoriUIFactory.button("Begin Journey", &"secondary")
	begin_button.name = "NewGameButton"
	begin_button.unique_name_in_owner = true
	menu_box.add_child(begin_button)
	begin_button.owner = self

	var settings_button := VezqoriUIFactory.button("Settings", &"secondary")
	settings_button.name = "OptionsButton"
	settings_button.unique_name_in_owner = true
	menu_box.add_child(settings_button)
	settings_button.owner = self

	var credits_button := VezqoriUIFactory.button("Credits", &"ghost")
	credits_button.name = "CreditsButton"
	credits_button.unique_name_in_owner = true
	menu_box.add_child(credits_button)
	credits_button.owner = self

	_route_note = VezqoriUIFactory.label(
		"Continue and Begin use distinct local routes into the same placeholder Home Shell.",
		&"caption"
	)
	_route_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content_column.add_child(_route_note)

	var footer := VezqoriUIFactory.label("Foundation only  •  offline local state  •  no backend connected", &"caption")
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shell.add_child(footer)

	var confirmation := CONFIRMATION_SCENE.instantiate()
	confirmation.name = "ExitConfirmation"
	confirmation.unique_name_in_owner = true
	confirmation.visible = false
	confirmation.title = "Leave VEZQORI?"
	confirmation.text = "Close the local foundation shell?"
	confirmation.confirm_button_text = "Quit"
	confirmation.close_button_text = "Stay"
	add_child(confirmation)
	confirmation.owner = self
	VezqoriUITokens.style_panel(confirmation, &"overlay")
	var cancel_button := confirmation.find_child("CloseButton", true, false) as Button
	var confirm_button := confirmation.find_child("ConfirmButton", true, false) as Button
	if cancel_button:
		VezqoriUITokens.style_button(cancel_button, &"ghost")
	if confirm_button:
		VezqoriUITokens.style_button(confirm_button, &"danger")

	_continue_button.pressed.connect(_on_continue_journey_pressed)
	begin_button.pressed.connect(_on_new_game_button_pressed)
	settings_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	_desktop_exit_button.pressed.connect(_on_exit_button_pressed)
	confirmation.confirmed.connect(_on_exit_confirmation_confirmed)
	resized.connect(_apply_responsive_layout)

func _ready() -> void:
	super._ready()
	_desktop_exit_button.visible = not OS.has_feature("mobile") and not OS.has_feature("web")
	call_deferred("_apply_responsive_layout")
	call_deferred("_focus_primary_action")

func _focus_primary_action() -> void:
	if is_instance_valid(_continue_button):
		_continue_button.grab_focus()
	await get_tree().process_frame
	if is_instance_valid(_welcome_scroll):
		_welcome_scroll.scroll_vertical = 0

func _apply_responsive_layout() -> void:
	if not is_instance_valid(_content_column):
		return
	var viewport_size := get_viewport_rect().size
	_content_column.custom_minimum_size.x = clampf(viewport_size.x - 40.0, 304.0, 520.0)
	if is_instance_valid(_wordmark):
		_wordmark.add_theme_font_size_override(&"font_size", 38 if viewport_size.x <= 375.0 else (44 if viewport_size.x < 600.0 else 54))
	if is_instance_valid(_hero_panel):
		_hero_panel.visible = viewport_size.y > 700.0
		_hero_panel.custom_minimum_size.y = 96.0
	if is_instance_valid(_desktop_exit_button):
		_desktop_exit_button.visible = viewport_size.x >= 900.0 and not OS.has_feature("mobile") and not OS.has_feature("web")

func new_game() -> void:
	VezqoriShellState.set_entry_route(&"begin")
	VezqoriShellState.set_active_tab(&"home")
	load_game_scene()

func _on_continue_journey_pressed() -> void:
	VezqoriShellState.set_entry_route(&"continue")
	VezqoriShellState.set_active_tab(&"home")
	load_game_scene()
