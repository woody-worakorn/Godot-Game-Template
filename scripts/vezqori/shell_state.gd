class_name VezqoriShellState
extends RefCounted

static var entry_route: StringName = &"begin"
static var active_tab: StringName = &"home"

static func set_entry_route(route: StringName) -> void:
	entry_route = route

static func set_active_tab(tab: StringName) -> void:
	active_tab = tab
