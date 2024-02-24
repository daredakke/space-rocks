class_name GameOver
extends Control


signal restart_game

@onready var final_score_label: RichTextLabel = %FinalScoreLabel
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	hide()
	restart_button.pressed.connect(_on_restart_game_button_pressed)


func update_score_label(value: int, max_score: int) -> void:
	final_score_label.text = "[center]" + Utils.format_integer(clampi(value, 0, max_score))


func _on_restart_game_button_pressed() -> void:
	hide()
	restart_game.emit()
