class_name VezqoriSettingsScreen
extends Control

var _back_button: Button
var _master_slider: HSlider
var _master_value: Label
var _mute_toggle: Button
var _viewport_label: Label
var _loading_values := false

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = VezqoriUITokens.make_theme()
	_build_ui()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var backdrop := VezqoriAmbientBackdrop.new()
	add_child(backdrop)

	var safe_area := VezqoriSafeAreaRoot.new()
	safe_area.name = "SafeAreaRoot"
	add_child(safe_area)

	var shell := VBoxContainer.new()
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_MD)
	safe_area.add_child(shell)

	var header := HBoxContainer.new()
	header.custom_minimum_size.y = VezqoriUITokens.TOUCH_MIN
	shell.add_child(header)
	_back_button = VezqoriUIFactory.button("Back", &"ghost", true)
	_back_button.name = "BackButton"
	_back_button.unique_name_in_owner = true
	header.add_child(_back_button)
	var title := VezqoriUIFactory.label("Settings", &"hero")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(title)
	var local_badge := VezqoriUIFactory.badge("LOCAL")
	header.add_child(local_badge)

	var scroll := ScrollContainer.new()
	scroll.name = "SettingsScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	shell.add_child(scroll)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)
	var column := VBoxContainer.new()
	column.name = "SettingsColumn"
	column.custom_minimum_size.x = 310.0
	column.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_MD)
	center.add_child(column)

	var intro := VezqoriUIFactory.label(
		"Device-friendly controls for this foundation shell. Audio changes are real and saved locally.",
		&"body"
	)
	column.add_child(intro)

	var sound_panel := VezqoriUIFactory.panel(&"glass")
	column.add_child(sound_panel)
	var sound_box := VBoxContainer.new()
	sound_box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	sound_panel.add_child(sound_box)
	sound_box.add_child(VezqoriUIFactory.label("Sound", &"section"))
	var master_header := HBoxContainer.new()
	sound_box.add_child(master_header)
	var master_title := VezqoriUIFactory.label("Master volume", &"body")
	master_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	master_header.add_child(master_title)
	_master_value = VezqoriUIFactory.label("100%", &"badge")
	_master_value.name = "MasterValueLabel"
	_master_value.unique_name_in_owner = true
	master_header.add_child(_master_value)

	_master_slider = HSlider.new()
	_master_slider.name = "MasterVolumeSlider"
	_master_slider.unique_name_in_owner = true
	_master_slider.min_value = 0.0
	_master_slider.max_value = 1.0
	_master_slider.step = 0.05
	_master_slider.tick_count = 11
	_master_slider.ticks_on_borders = true
	VezqoriUITokens.style_slider(_master_slider)
	sound_box.add_child(_master_slider)

	_mute_toggle = VezqoriUIFactory.button("Mute all audio: Off", &"secondary")
	_mute_toggle.name = "MuteToggle"
	_mute_toggle.unique_name_in_owner = true
	_mute_toggle.toggle_mode = true
	sound_box.add_child(_mute_toggle)

	var mobile_panel := VezqoriUIFactory.panel(&"card")
	column.add_child(mobile_panel)
	var mobile_box := VBoxContainer.new()
	mobile_box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	mobile_panel.add_child(mobile_box)
	mobile_box.add_child(VezqoriUIFactory.label("Mobile shell", &"section"))
	mobile_box.add_child(VezqoriUIFactory.label(
		"Large targets, safe-area padding and scrollable compact layouts are enabled. Desktop-only resolution and fullscreen controls stay outside this mobile-facing screen.",
		&"body"
	))
	_viewport_label = VezqoriUIFactory.label("Viewport", &"badge")
	mobile_box.add_child(_viewport_label)

	var privacy_panel := VezqoriUIFactory.panel(&"soft")
	column.add_child(privacy_panel)
	var privacy_box := VBoxContainer.new()
	privacy_box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_XS)
	privacy_panel.add_child(privacy_box)
	privacy_box.add_child(VezqoriUIFactory.label("Foundation boundary", &"section"))
	privacy_box.add_child(VezqoriUIFactory.label(
		"No account, cloud sync, health connection or online service is active in this task.",
		&"body"
	))
	privacy_box.add_child(VezqoriUIFactory.badge("MOCK / LOCAL ONLY"))

	_back_button.pressed.connect(_close)
	_master_slider.value_changed.connect(_on_master_volume_changed)
	_mute_toggle.toggled.connect(_on_mute_toggled)
	resized.connect(_refresh_viewport_label)

func _ready() -> void:
	_load_values()
	_refresh_viewport_label()
	call_deferred("_focus_back")

func _focus_back() -> void:
	if is_instance_valid(_back_button):
		_back_button.grab_focus()

func _load_values() -> void:
	_loading_values = true
	var bus_name := AppSettings.get_audio_bus_name(AppSettings.MASTER_BUS_INDEX).to_pascal_case()
	var current_volume := float(PlayerConfig.get_config(AppSettings.AUDIO_SECTION, bus_name, AppSettings.get_bus_volume(AppSettings.MASTER_BUS_INDEX)))
	_master_slider.value = clampf(current_volume, 0.0, 1.0)
	var muted := bool(PlayerConfig.get_config(AppSettings.AUDIO_SECTION, AppSettings.MUTE_SETTING, AppSettings.is_muted()))
	_mute_toggle.button_pressed = muted
	_refresh_mute_text(muted)
	_refresh_volume_text(_master_slider.value)
	_loading_values = false

func _on_master_volume_changed(value: float) -> void:
	_refresh_volume_text(value)
	if _loading_values:
		return
	AppSettings.set_bus_volume(AppSettings.MASTER_BUS_INDEX, value)
	var bus_name := AppSettings.get_audio_bus_name(AppSettings.MASTER_BUS_INDEX).to_pascal_case()
	PlayerConfig.set_config(AppSettings.AUDIO_SECTION, bus_name, value)

func _on_mute_toggled(value: bool) -> void:
	_refresh_mute_text(value)
	if _loading_values:
		return
	AppSettings.set_mute(value)
	PlayerConfig.set_config(AppSettings.AUDIO_SECTION, AppSettings.MUTE_SETTING, value)

func _refresh_volume_text(value: float) -> void:
	_master_value.text = "%d%%" % roundi(value * 100.0)

func _refresh_mute_text(value: bool) -> void:
	_mute_toggle.text = "Mute all audio: %s" % ("On" if value else "Off")

func _refresh_viewport_label() -> void:
	if not is_instance_valid(_viewport_label):
		return
	var current_size := get_viewport_rect().size
	_viewport_label.text = "VIEWPORT  %d × %d" % [roundi(current_size.x), roundi(current_size.y)]

func _close() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		_close()
