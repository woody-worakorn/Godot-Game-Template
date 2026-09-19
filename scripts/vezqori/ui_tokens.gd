class_name VezqoriUITokens
extends RefCounted

const MIDNIGHT := Color("#07162E")
const MIDNIGHT_RAISED := Color("#0D2344")
const NAVY := Color("#102E57")
const TEAL := Color("#54D6CC")
const AQUA := Color("#A8F0E8")
const VIOLET := Color("#8C7CFF")
const CREAM := Color("#FFF4D8")
const TEXT := Color("#F5F8FF")
const TEXT_MUTED := Color("#9DB4CC")
const TEXT_DARK := Color("#0A1B45")
const SURFACE := Color("#10284C")
const SURFACE_SOFT := Color("#17365D")
const BORDER := Color(0.45, 0.82, 0.82, 0.28)
const OVERLAY := Color(0.02, 0.07, 0.16, 0.92)
const DANGER := Color("#D97B91")

const SPACE_XS := 6
const SPACE_SM := 10
const SPACE_MD := 16
const SPACE_LG := 24
const SPACE_XL := 34
const TOUCH_MIN := 54.0
const CONTENT_MAX := 720.0

static func make_theme() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 16
	theme.set_color(&"font_color", &"Label", TEXT)
	theme.set_color(&"font_color", &"RichTextLabel", TEXT)
	theme.set_color(&"default_color", &"RichTextLabel", TEXT)
	theme.set_color(&"font_color", &"Button", TEXT)
	theme.set_color(&"font_hover_color", &"Button", CREAM)
	theme.set_color(&"font_pressed_color", &"Button", CREAM)
	theme.set_color(&"font_focus_color", &"Button", CREAM)
	theme.set_color(&"font_color", &"CheckButton", TEXT)
	theme.set_color(&"font_hover_color", &"CheckButton", CREAM)
	theme.set_constant(&"separation", &"VBoxContainer", SPACE_SM)
	theme.set_constant(&"separation", &"HBoxContainer", SPACE_SM)
	return theme

static func make_style(
		background: Color,
		border: Color = BORDER,
		radius: int = 18,
		border_width: int = 1,
		padding_h: int = 16,
		padding_v: int = 12
	) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
	style.content_margin_left = padding_h
	style.content_margin_right = padding_h
	style.content_margin_top = padding_v
	style.content_margin_bottom = padding_v
	return style

static func style_panel(panel: PanelContainer, variant: StringName = &"card") -> void:
	var style: StyleBoxFlat
	match variant:
		&"glass":
			style = make_style(Color(0.07, 0.18, 0.35, 0.78), Color(0.45, 0.95, 0.90, 0.30), 24, 1, 20, 18)
		&"soft":
			style = make_style(Color(0.09, 0.23, 0.39, 0.92), Color(0.55, 0.50, 1.0, 0.24), 20, 1, 18, 16)
		&"nav":
			style = make_style(Color(0.04, 0.12, 0.25, 0.96), Color(0.45, 0.92, 0.88, 0.24), 24, 1, 8, 8)
		&"overlay":
			style = make_style(OVERLAY, Color(0.55, 0.50, 1.0, 0.34), 26, 1, 22, 20)
		_:
			style = make_style(Color(0.06, 0.16, 0.31, 0.92), BORDER, 20, 1, 18, 16)
	panel.add_theme_stylebox_override(&"panel", style)

static func style_button(button: Button, variant: StringName = &"secondary", compact: bool = false) -> void:
	var normal: StyleBoxFlat
	var hover: StyleBoxFlat
	var pressed: StyleBoxFlat
	var focus: StyleBoxFlat
	var font_color := TEXT
	match variant:
		&"primary":
			normal = make_style(Color("#185E72"), Color(0.45, 0.96, 0.90, 0.70), 20, 1, 18, 12)
			hover = make_style(Color("#1D7282"), AQUA, 20, 2, 18, 12)
			pressed = make_style(Color("#124B61"), TEAL, 20, 2, 18, 12)
			focus = make_style(Color("#185E72"), CREAM, 20, 2, 18, 12)
		&"ghost":
			normal = make_style(Color(0.0, 0.0, 0.0, 0.0), Color(0.45, 0.82, 0.82, 0.18), 16, 1, 12, 8)
			hover = make_style(Color(0.20, 0.60, 0.65, 0.18), TEAL, 16, 1, 12, 8)
			pressed = make_style(Color(0.20, 0.60, 0.65, 0.28), AQUA, 16, 1, 12, 8)
			focus = make_style(Color(0.20, 0.60, 0.65, 0.16), CREAM, 16, 2, 12, 8)
		&"nav_active":
			normal = make_style(Color(0.20, 0.66, 0.66, 0.32), TEAL, 16, 1, 6, 8)
			hover = make_style(Color(0.24, 0.72, 0.72, 0.40), AQUA, 16, 1, 6, 8)
			pressed = make_style(Color(0.18, 0.54, 0.60, 0.46), TEAL, 16, 2, 6, 8)
			focus = make_style(Color(0.20, 0.66, 0.66, 0.32), CREAM, 16, 2, 6, 8)
		&"nav":
			normal = make_style(Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 0.0), 16, 0, 6, 8)
			hover = make_style(Color(0.20, 0.60, 0.65, 0.16), Color(0.45, 0.92, 0.88, 0.28), 16, 1, 6, 8)
			pressed = make_style(Color(0.20, 0.60, 0.65, 0.24), TEAL, 16, 1, 6, 8)
			focus = make_style(Color(0.0, 0.0, 0.0, 0.0), AQUA, 16, 2, 6, 8)
		&"danger":
			normal = make_style(Color(0.45, 0.14, 0.24, 0.48), Color(0.95, 0.48, 0.58, 0.55), 18, 1, 16, 10)
			hover = make_style(Color(0.55, 0.18, 0.28, 0.60), DANGER, 18, 2, 16, 10)
			pressed = make_style(Color(0.38, 0.10, 0.19, 0.72), DANGER, 18, 2, 16, 10)
			focus = make_style(Color(0.45, 0.14, 0.24, 0.56), CREAM, 18, 2, 16, 10)
		_:
			normal = make_style(Color(0.08, 0.22, 0.40, 0.92), Color(0.45, 0.82, 0.82, 0.32), 18, 1, 16, 10)
			hover = make_style(Color(0.12, 0.31, 0.49, 0.96), TEAL, 18, 1, 16, 10)
			pressed = make_style(Color(0.07, 0.18, 0.35, 1.0), AQUA, 18, 2, 16, 10)
			focus = make_style(Color(0.10, 0.27, 0.45, 0.98), CREAM, 18, 2, 16, 10)
	button.add_theme_stylebox_override(&"normal", normal)
	button.add_theme_stylebox_override(&"hover", hover)
	button.add_theme_stylebox_override(&"pressed", pressed)
	button.add_theme_stylebox_override(&"focus", focus)
	button.add_theme_color_override(&"font_color", font_color)
	button.add_theme_color_override(&"font_hover_color", CREAM)
	button.add_theme_color_override(&"font_pressed_color", CREAM)
	button.add_theme_color_override(&"font_focus_color", CREAM)
	button.add_theme_font_size_override(&"font_size", 13 if compact else 16)
	button.custom_minimum_size.y = 48.0 if compact else TOUCH_MIN
	button.focus_mode = Control.FOCUS_ALL

static func style_label(label: Label, role: StringName = &"body") -> void:
	match role:
		&"brand":
			label.add_theme_color_override(&"font_color", CREAM)
			label.add_theme_font_size_override(&"font_size", 44)
			label.add_theme_constant_override(&"outline_size", 8)
			label.add_theme_color_override(&"font_outline_color", Color(0.20, 0.85, 0.78, 0.16))
		&"hero":
			label.add_theme_color_override(&"font_color", TEXT)
			label.add_theme_font_size_override(&"font_size", 30)
		&"section":
			label.add_theme_color_override(&"font_color", AQUA)
			label.add_theme_font_size_override(&"font_size", 20)
		&"caption":
			label.add_theme_color_override(&"font_color", TEXT_MUTED)
			label.add_theme_font_size_override(&"font_size", 12)
		&"badge":
			label.add_theme_color_override(&"font_color", TEAL)
			label.add_theme_font_size_override(&"font_size", 11)
		&"nav":
			label.add_theme_color_override(&"font_color", TEXT_MUTED)
			label.add_theme_font_size_override(&"font_size", 11)
		_:
			label.add_theme_color_override(&"font_color", TEXT_MUTED)
			label.add_theme_font_size_override(&"font_size", 15)

static func style_toggle(toggle: CheckButton) -> void:
	toggle.custom_minimum_size.y = TOUCH_MIN
	toggle.add_theme_font_size_override(&"font_size", 15)
	toggle.add_theme_color_override(&"font_color", TEXT)
	toggle.add_theme_color_override(&"font_hover_color", CREAM)

static func style_slider(slider: HSlider) -> void:
	slider.custom_minimum_size.y = TOUCH_MIN
	slider.add_theme_stylebox_override(&"slider", make_style(Color(0.15, 0.30, 0.48, 0.92), Color(0.45, 0.82, 0.82, 0.24), 8, 1, 0, 0))
	slider.add_theme_stylebox_override(&"grabber_area", make_style(Color(0.25, 0.78, 0.74, 0.72), TEAL, 8, 1, 0, 0))
	slider.add_theme_stylebox_override(&"grabber_area_highlight", make_style(Color(0.35, 0.90, 0.85, 0.86), CREAM, 8, 1, 0, 0))
