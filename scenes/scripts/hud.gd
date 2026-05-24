extends Control

@export var min_icon_size := 32
@export var max_icon_size := 96
@export var min_score_font_size := 20
@export var max_score_font_size := 64

@onready var lives_container: HBoxContainer = $HBoxContainer
@onready var score_label: Label = $"../ScoreLabel"


func _ready() -> void:
	resized.connect(_update_layout)
	_update_layout()


func _update_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var short_side := minf(viewport_size.x, viewport_size.y)
	var margin := roundi(clampf(short_side * 0.025, 12.0, 48.0))
	var icon_size := roundi(clampf(short_side * 0.075, min_icon_size, max_icon_size))
	var score_font_size := roundi(clampf(short_side * 0.045, min_score_font_size, max_score_font_size))

	lives_container.scale = Vector2.ONE
	lives_container.position = Vector2(margin, margin)
	lives_container.add_theme_constant_override("separation", roundi(icon_size * 0.15))

	for child in lives_container.get_children():
		if child is TextureRect:
			child.custom_minimum_size = Vector2(icon_size, icon_size)
			child.size = child.custom_minimum_size

	score_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	score_label.offset_left = 0.0
	score_label.offset_right = 0.0
	score_label.offset_top = margin
	score_label.offset_bottom = margin + score_font_size * 1.5
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.add_theme_font_size_override("font_size", score_font_size)
