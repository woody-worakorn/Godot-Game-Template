class_name VezqoriHomeShell
extends Control

const PAUSE_MENU_SCENE := preload("res://scenes/vezqori/pause/pause_menu.tscn")
const PAUSE_CONTROLLER_SCRIPT := preload("res://addons/maaacks_game_template/base/nodes/utilities/pause_menu_controller.gd")

const TAB_ORDER := [&"home", &"qori", &"journey", &"collection", &"profile"]
const TAB_DATA := {
	&"home": {
		"label": "Home",
		"eyebrow": "HOME SHELL",
		"title": "A calm place to begin",
		"body": "This local shell proves navigation, layout and pause behavior without introducing creature gameplay.",
		"hero": "World placeholder",
		"detail": "Future environment and Qori presentation will live here after the relevant product phase opens.",
		"cards": ["Local time", "No live data", "Foundation state", "Ready for review"]
	},
	&"qori": {
		"label": "Qori",
		"eyebrow": "QORI PLACEHOLDER",
		"title": "Your companion space",
		"body": "The Qori tab is navigation-only in TASK-001. No creature artwork, care loop or gameplay has been migrated.",
		"hero": "Qori slot reserved",
		"detail": "MOCK / PLACEHOLDER — intentionally empty until an authorized Qori task.",
		"cards": ["Identity: later", "Care: later", "Bond: later", "Mood: later"]
	},
	&"journey": {
		"label": "Journey",
		"eyebrow": "JOURNEY PLACEHOLDER",
		"title": "Your path will unfold here",
		"body": "Future milestones and story moments can use this route. No progression or reward system is implemented.",
		"hero": "Journey map reserved",
		"detail": "Local tab switching only. No backend, economy, event system or production state.",
		"cards": ["Milestones: mock", "Story: mock", "Signals: mock", "Rewards: none"]
	},
	&"collection": {
		"label": "Collection",
		"eyebrow": "COLLECTION PLACEHOLDER",
		"title": "A library for future memories",
		"body": "This tab demonstrates a stable destination for future items and records without adding inventory or marketplace behavior.",
		"hero": "Collection grid reserved",
		"detail": "MOCK / PLACEHOLDER — no items, ownership, trade or production economy.",
		"cards": ["Items: none", "Memories: mock", "Archive: mock", "Trade: disabled"]
	},
	&"profile": {
		"label": "Profile",
		"eyebrow": "PROFILE PLACEHOLDER",
		"title": "Your local shell profile",
		"body": "A presentation-only profile destination. Authentication, accounts, friends and cloud sync remain out of scope.",
		"hero": "Local guest profile",
		"detail": "Offline foundation state. No personal account or network identity is active.",
		"cards": ["Account: none", "Sync: off", "Friends: none", "Privacy: local"]
	}
}

var _shell_width_target: Control
var _content_panel: PanelContainer
var _nav_panel: PanelContainer
var _cards_grid: GridContainer
var _eyebrow_label: Label
var _title_label: Label
var _body_label: Label
var _hero_title: Label
var _hero_detail: Label
var _card_labels: Array[Label] = []
var _nav_buttons: Dictionary = {}
var _route_badge_label: Label
var _pause_controller: Node

func _enter_tree() -> void:
	theme = VezqoriUITokens.make_theme()
	_build_ui()
	_build_pause_controller()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(VezqoriAmbientBackdrop.new())

	var safe_area := VezqoriSafeAreaRoot.new()
	safe_area.name = "SafeAreaRoot"
	add_child(safe_area)
	var shell := VBoxContainer.new()
	shell.name = "HomeShellLayout"
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	safe_area.add_child(shell)

	var header_center := CenterContainer.new()
	header_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.add_child(header_center)
	var header := HBoxContainer.new()
	header.name = "Header"
	header.custom_minimum_size.y = VezqoriUITokens.TOUCH_MIN
	header.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	header_center.add_child(header)
	_shell_width_target = header

	var brand := VezqoriUIFactory.label("VEZQORI", &"section")
	brand.add_theme_font_size_override(&"font_size", 17)
	header.add_child(brand)
	header.add_child(VezqoriUIFactory.expanding_spacer())

	var route_badge := VezqoriUIFactory.panel(&"soft")
	header.add_child(route_badge)
	_route_badge_label = VezqoriUIFactory.label("LOCAL ROUTE", &"badge")
	_route_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	route_badge.add_child(_route_badge_label)

	var pause_button := VezqoriUIFactory.button("Pause", &"ghost", true)
	pause_button.name = "PauseButton"
	pause_button.unique_name_in_owner = true
	header.add_child(pause_button)
	pause_button.pressed.connect(_open_pause)

	_content_panel = VezqoriUIFactory.panel(&"glass")
	_content_panel.name = "ContentPanel"
	_content_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_child(_content_panel)

	var scroll := ScrollContainer.new()
	scroll.name = "HomeContentScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_content_panel.add_child(scroll)
	var content := VBoxContainer.new()
	content.name = "TabContent"
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_SM)
	scroll.add_child(content)

	_eyebrow_label = VezqoriUIFactory.label("HOME SHELL", &"badge")
	content.add_child(_eyebrow_label)
	_title_label = VezqoriUIFactory.label("A calm place to begin", &"hero")
	content.add_child(_title_label)
	_body_label = VezqoriUIFactory.label("", &"body")
	content.add_child(_body_label)

	var hero := VezqoriUIFactory.panel(&"soft")
	hero.custom_minimum_size.y = 142.0
	content.add_child(hero)
	var hero_box := VBoxContainer.new()
	hero_box.alignment = BoxContainer.ALIGNMENT_CENTER
	hero_box.add_theme_constant_override(&"separation", VezqoriUITokens.SPACE_XS)
	hero.add_child(hero_box)
	var orbit := VezqoriUIFactory.label("◌", &"brand")
	orbit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	orbit.add_theme_font_size_override(&"font_size", 34)
	hero_box.add_child(orbit)
	_hero_title = VezqoriUIFactory.label("World placeholder", &"section")
	_hero_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_box.add_child(_hero_title)
	_hero_detail = VezqoriUIFactory.label("", &"caption")
	_hero_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_box.add_child(_hero_detail)

	_cards_grid = GridContainer.new()
	_cards_grid.name = "PlaceholderCards"
	_cards_grid.columns = 1
	_cards_grid.add_theme_constant_override(&"h_separation", VezqoriUITokens.SPACE_SM)
	_cards_grid.add_theme_constant_override(&"v_separation", VezqoriUITokens.SPACE_SM)
	content.add_child(_cards_grid)
	for index in range(4):
		var card := VezqoriUIFactory.panel(&"card")
		card.custom_minimum_size.y = 62.0
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_cards_grid.add_child(card)
		var card_label := VezqoriUIFactory.label("Placeholder", &"caption")
		card_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		card_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		card_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card.add_child(card_label)
		_card_labels.append(card_label)

	var mock_badge := VezqoriUIFactory.badge("MOCK / PLACEHOLDER  •  LOCAL STATE")
	mock_badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content.add_child(mock_badge)

	var nav_center := CenterContainer.new()
	nav_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.add_child(nav_center)
	_nav_panel = VezqoriUIFactory.panel(&"nav")
	_nav_panel.name = "BottomNavigation"
	_nav_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	nav_center.add_child(_nav_panel)
	var nav_box := HBoxContainer.new()
	nav_box.name = "BottomNavButtons"
	nav_box.add_theme_constant_override(&"separation", 4)
	_nav_panel.add_child(nav_box)

	for tab in TAB_ORDER:
		var data: Dictionary = TAB_DATA[tab]
		var nav_button := VezqoriUIFactory.button(String(data["label"]), &"nav", true)
		nav_button.name = "%sTabButton" % String(tab).capitalize().replace(" ", "")
		nav_button.unique_name_in_owner = true
		nav_button.toggle_mode = true
		nav_button.custom_minimum_size.x = 58.0
		nav_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		nav_button.pressed.connect(_select_tab.bind(tab))
		nav_box.add_child(nav_button)
		_nav_buttons[tab] = nav_button

	resized.connect(_apply_responsive_layout)

func _build_pause_controller() -> void:
	_pause_controller = Node.new()
	_pause_controller.name = "PauseMenuController"
	_pause_controller.set_script(PAUSE_CONTROLLER_SCRIPT)
	_pause_controller.set("pause_menu_packed", PAUSE_MENU_SCENE)
	add_child(_pause_controller)

func _ready() -> void:
	var route_text := "CONTINUE ROUTE" if VezqoriShellState.entry_route == &"continue" else "BEGIN ROUTE"
	_route_badge_label.text = "%s  •  LOCAL" % route_text
	var tab := VezqoriShellState.active_tab
	if tab not in TAB_ORDER:
		tab = &"home"
	_select_tab(tab)
	call_deferred("_apply_responsive_layout")
	call_deferred("_focus_active_tab")

func _focus_active_tab() -> void:
	var active := VezqoriShellState.active_tab
	if _nav_buttons.has(active):
		(_nav_buttons[active] as Button).grab_focus()

func _select_tab(tab: StringName) -> void:
	if not TAB_DATA.has(tab):
		return
	VezqoriShellState.set_active_tab(tab)
	var data: Dictionary = TAB_DATA[tab]
	_eyebrow_label.text = String(data["eyebrow"])
	_title_label.text = String(data["title"])
	_body_label.text = String(data["body"])
	_hero_title.text = String(data["hero"])
	_hero_detail.text = String(data["detail"])
	var cards: Array = data["cards"]
	for index in range(_card_labels.size()):
		_card_labels[index].text = String(cards[index])
	for key in _nav_buttons:
		var button := _nav_buttons[key] as Button
		button.button_pressed = key == tab
		VezqoriUITokens.style_button(button, &"nav_active" if key == tab else &"nav", true)

func _open_pause() -> void:
	if is_instance_valid(_pause_controller) and _pause_controller.has_method("pause"):
		_pause_controller.call("pause")

func _apply_responsive_layout() -> void:
	if not is_instance_valid(_content_panel):
		return
	var viewport_size := get_viewport_rect().size
	var horizontal_allowance := 36.0 if viewport_size.x <= 375.0 else (48.0 if viewport_size.x < 600.0 else 68.0)
	var target_width := clampf(viewport_size.x - horizontal_allowance, 300.0, VezqoriUITokens.CONTENT_MAX)
	_content_panel.custom_minimum_size.x = target_width
	if is_instance_valid(_shell_width_target):
		_shell_width_target.custom_minimum_size.x = target_width
	if is_instance_valid(_nav_panel):
		_nav_panel.custom_minimum_size.x = target_width
	_cards_grid.columns = 2 if viewport_size.x >= 640.0 else 1
	_title_label.add_theme_font_size_override(&"font_size", 26 if viewport_size.x < 600.0 else 32)
