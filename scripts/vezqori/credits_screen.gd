class_name VezqoriCreditsScreen
extends Control

var _back_button: Button

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = VezqoriUITokens.make_theme()
	_build_ui()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(VezqoriAmbientBackdrop.new())

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
	var title := VezqoriUIFactory.label("Credits", &"hero")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(title)
	header.add_child(VezqoriUIFactory.badge("ATTRIBUTION"))

	var scroll := ScrollContainer.new()
	scroll.name = "CreditsScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	shell.add_child(scroll)
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = 310.0
	column.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_MD)
	center.add_child(column)

	var brand := VezqoriUIFactory.label("VEZQORI", &"brand")
	brand.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(brand)
	var subtitle := VezqoriUIFactory.label("Foundation Shell v0.1", &"section")
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(subtitle)
	var intro := VezqoriUIFactory.label(
		"A creature-raising life game in development. This screen preserves the open-source foundation credits used by the local shell.",
		&"body"
	)
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(intro)

	_add_credit_card(column, "VEZQORI project", "Product direction and application shell by the VEZQORI project team. Current runtime content is a local mock with no production gameplay or backend.")
	_add_credit_card(column, "Maaack's Godot Game Template", "Created by Marek Belski and contributors. Source: github.com/Maaack/Godot-Game-Template. Licensed under the MIT License. The upstream copyright and permission notice remain in LICENSE.txt and ATTRIBUTION.md.")
	_add_credit_card(column, "Godot Engine", "Created by Juan Linietsky, Ariel Manzur and contributors. Godot Engine is licensed under the MIT License.")
	_add_credit_card(column, "Bundled reference assets", "Godot Engine logo: CC BY 4.0. Git logo: CC BY 3.0. Full source and attribution details remain in ATTRIBUTION.md.")

	var legal := VezqoriUIFactory.panel(&"soft")
	column.add_child(legal)
	var legal_copy := VezqoriUIFactory.label(
		"Required attribution is retained. Later visual replacement must reconcile licenses deliberately rather than deleting upstream notices.",
		&"caption"
	)
	legal.add_child(legal_copy)

	_back_button.pressed.connect(_close)

func _add_credit_card(parent: VBoxContainer, heading: String, copy: String) -> void:
	var panel := VezqoriUIFactory.panel(&"card")
	parent.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_XS)
	panel.add_child(box)
	box.add_child(VezqoriUIFactory.label(heading, &"section"))
	box.add_child(VezqoriUIFactory.label(copy, &"body"))

func _ready() -> void:
	call_deferred("_focus_back")

func _focus_back() -> void:
	if is_instance_valid(_back_button):
		_back_button.grab_focus()

func _close() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		_close()
