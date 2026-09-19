extends "res://scenes/windows/pause_menu.gd"

func _ready() -> void:
	theme = VezqoriUITokens.make_theme()
	super._ready()
	VezqoriUITokens.style_panel(self, &"overlay")
	var resume_button := find_child("CloseButton", true, false) as Button
	var restart_button := find_child("RestartButton", true, false) as Button
	var settings_button := find_child("OptionsButton", true, false) as Button
	var welcome_button := find_child("MainMenuButton", true, false) as Button
	var quit_button := find_child("ExitButton", true, false) as Button
	if resume_button:
		VezqoriUITokens.style_button(resume_button, &"primary")
	if restart_button:
		restart_button.hide()
	if settings_button:
		VezqoriUITokens.style_button(settings_button, &"secondary")
	if welcome_button:
		VezqoriUITokens.style_button(welcome_button, &"secondary")
	if quit_button:
		VezqoriUITokens.style_button(quit_button, &"ghost")
		quit_button.visible = not OS.has_feature("mobile") and not OS.has_feature("web")
	_style_confirmation(restart_confirmation, &"secondary")
	_style_confirmation(main_menu_confirmation, &"primary")
	_style_confirmation(exit_confirmation, &"danger")

func _style_confirmation(dialog: Control, confirm_variant: StringName) -> void:
	if not is_instance_valid(dialog):
		return
	# Keep confirmations inside the already-overlaid pause menu. This avoids a second runtime reparent cycle.
	dialog.parent_scene = null
	VezqoriUITokens.style_panel(dialog as PanelContainer, &"overlay")
	var cancel_button := dialog.find_child("CloseButton", true, false) as Button
	var confirm_button := dialog.find_child("ConfirmButton", true, false) as Button
	if cancel_button:
		cancel_button.text = str(dialog.get("close_button_text"))
		VezqoriUITokens.style_button(cancel_button, &"ghost")
	if confirm_button:
		confirm_button.text = str(dialog.get("confirm_button_text"))
		VezqoriUITokens.style_button(confirm_button, confirm_variant)
