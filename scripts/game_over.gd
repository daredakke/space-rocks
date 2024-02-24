class_name GameOver
extends Control


signal restart_game
signal quit_game

@onready var final_score_label: RichTextLabel = %FinalScoreLabel
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	hide()
	restart_button.pressed.connect(_on_restart_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func update_score_label(value: int, max_score: int) -> void:
	final_score_label.text = "[center]" + Utils.format_integer(clampi(value, 0, max_score))


func _on_restart_game_button_pressed() -> void:
	hide()
	restart_game.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
