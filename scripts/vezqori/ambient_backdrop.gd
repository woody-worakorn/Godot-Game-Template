class_name VezqoriAmbientBackdrop
extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	resized.connect(queue_redraw)
	queue_redraw()

func _draw() -> void:
	var bands := 24
	for index in range(bands):
		var ratio := float(index) / float(maxi(1, bands - 1))
		var color := VezqoriUITokens.MIDNIGHT.lerp(Color("#0A2142"), ratio)
		var band_height := size.y / float(bands) + 1.0
		draw_rect(Rect2(0.0, ratio * size.y, size.x, band_height), color)

	var unit := minf(size.x, size.y)
	draw_circle(Vector2(size.x * 0.82, size.y * 0.12), unit * 0.24, Color(0.24, 0.92, 0.82, 0.055))
	draw_circle(Vector2(size.x * 0.12, size.y * 0.72), unit * 0.28, Color(0.50, 0.42, 1.0, 0.055))
	draw_circle(Vector2(size.x * 0.62, size.y * 0.78), unit * 0.18, Color(0.36, 0.78, 0.92, 0.035))

	var center := Vector2(size.x * 0.5, size.y * 0.31)
	for ring in range(3):
		draw_arc(center, unit * (0.12 + ring * 0.045), -2.55, 0.85, 56, Color(0.55, 0.95, 0.88, 0.10 - ring * 0.02), 1.4, true)

	var stars := [
		Vector2(0.10, 0.12), Vector2(0.19, 0.27), Vector2(0.31, 0.09),
		Vector2(0.74, 0.25), Vector2(0.90, 0.39), Vector2(0.82, 0.64),
		Vector2(0.22, 0.84), Vector2(0.56, 0.91), Vector2(0.42, 0.55)
	]
	for star in stars:
		draw_circle(Vector2(size.x * star.x, size.y * star.y), 1.6, Color(0.75, 0.96, 0.94, 0.42))
