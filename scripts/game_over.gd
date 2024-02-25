class_name GameOver
extends Control


signal restart_game
signal quit_game

const RIGHT_BB_CODE: String = "[right]"

@onready var final_score_value: RichTextLabel = %FinalScoreValue
@onready var rocks_destroyed_value: RichTextLabel = %RocksDestroyedValue
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	hide()
	restart_button.pressed.connect(_on_restart_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func update_score_label(value: int, max_score: int) -> void:
	var clamped_value: int = clampi(value, 0, max_score)
	final_score_value.text = RIGHT_BB_CODE + Utils.format_integer(clamped_value)


func update_rocks_destroyed_label(rocks_destroyed: int, max_rocks_destroyed: int) -> void:
	var clamped_value: int = clampi(rocks_destroyed, 0, max_rocks_destroyed)
	rocks_destroyed_value.text = RIGHT_BB_CODE + Utils.format_integer(clamped_value)


func _on_restart_game_button_pressed() -> void:
	hide()
	restart_game.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
