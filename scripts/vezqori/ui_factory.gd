class_name VezqoriUIFactory
extends RefCounted

static func label(text_value: String, role: StringName = &"body") -> Label:
	var node := Label.new()
	node.text = text_value
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if role in [&"body", &"hero", &"caption"] else TextServer.AUTOWRAP_OFF
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	VezqoriUITokens.style_label(node, role)
	return node

static func button(text_value: String, variant: StringName = &"secondary", compact: bool = false) -> Button:
	var node := Button.new()
	node.text = text_value
	VezqoriUITokens.style_button(node, variant, compact)
	return node

static func panel(variant: StringName = &"card") -> PanelContainer:
	var node := PanelContainer.new()
	VezqoriUITokens.style_panel(node, variant)
	return node

static func spacer(minimum_height: float = 8.0) -> Control:
	var node := Control.new()
	node.custom_minimum_size.y = minimum_height
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

static func expanding_spacer() -> Control:
	var node := Control.new()
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

static func badge(text_value: String) -> PanelContainer:
	var wrapper := panel(&"soft")
	wrapper.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var text_label := label(text_value, &"badge")
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wrapper.add_child(text_label)
	return wrapper

static func padded(child: Control, amount: int = VezqoriUITokens.SPACE_MD) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override(&"margin_left", amount)
	margin.add_theme_constant_override(&"margin_top", amount)
	margin.add_theme_constant_override(&"margin_right", amount)
	margin.add_theme_constant_override(&"margin_bottom", amount)
	margin.add_child(child)
	return margin
