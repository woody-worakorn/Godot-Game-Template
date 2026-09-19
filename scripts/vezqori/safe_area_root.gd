class_name VezqoriSafeAreaRoot
extends MarginContainer

@export var include_base_padding := true

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if not get_viewport().size_changed.is_connected(_apply_safe_area):
		get_viewport().size_changed.connect(_apply_safe_area)
	call_deferred("_apply_safe_area")

func _exit_tree() -> void:
	if get_viewport() and get_viewport().size_changed.is_connected(_apply_safe_area):
		get_viewport().size_changed.disconnect(_apply_safe_area)

func _apply_safe_area() -> void:
	var viewport_size := get_viewport_rect().size
	var base_horizontal := 0.0
	var base_top := 0.0
	var base_bottom := 0.0
	if include_base_padding:
		base_horizontal = 14.0 if viewport_size.x <= 375.0 else (20.0 if viewport_size.x < 600.0 else 32.0)
		base_top = 14.0 if viewport_size.y <= 680.0 else 20.0
		base_bottom = 14.0 if viewport_size.y <= 680.0 else 20.0

	var safe_left := 0.0
	var safe_top := 0.0
	var safe_right := 0.0
	var safe_bottom := 0.0
	if OS.has_feature("mobile"):
		var safe_rect := DisplayServer.get_display_safe_area()
		var screen_size := Vector2(DisplayServer.screen_get_size())
		if safe_rect.size.x > 0 and safe_rect.size.y > 0 and screen_size.x > 0 and screen_size.y > 0:
			var scale := Vector2(viewport_size.x / screen_size.x, viewport_size.y / screen_size.y)
			safe_left = float(safe_rect.position.x) * scale.x
			safe_top = float(safe_rect.position.y) * scale.y
			safe_right = maxf(0.0, screen_size.x - float(safe_rect.end.x)) * scale.x
			safe_bottom = maxf(0.0, screen_size.y - float(safe_rect.end.y)) * scale.y

	add_theme_constant_override(&"margin_left", roundi(base_horizontal + safe_left))
	add_theme_constant_override(&"margin_top", roundi(base_top + safe_top))
	add_theme_constant_override(&"margin_right", roundi(base_horizontal + safe_right))
	add_theme_constant_override(&"margin_bottom", roundi(base_bottom + safe_bottom))
