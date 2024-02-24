class_name Stats
extends Control


@onready var score_label: RichTextLabel = %ScoreLabel
@onready var shot_indicator_1: TextureRect = %ShotIndicator1
@onready var shot_indicator_2: TextureRect = %ShotIndicator2
@onready var shot_indicator_3: TextureRect = %ShotIndicator3
@onready var shot_indicators: Array[TextureRect] = [
	shot_indicator_1,
	shot_indicator_2,
	shot_indicator_3,
]


func toggle_shot_indicators(visible_count: int) -> void:
	var count: int = clampi(visible_count, 0, shot_indicators.size())
	
	for indicator in shot_indicators:
		indicator.visible = false
	
	for i in count:
		shot_indicators[i].visible = true


func update_score_label(value: int, max_score: int) -> void:
	score_label.text = "[right]" + Utils.format_integer(clampi(value, 0, max_score))
