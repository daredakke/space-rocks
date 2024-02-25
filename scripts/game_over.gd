class_name GameOver
extends Control


signal restart_game
signal quit_game

const RIGHT_BB_CODE: String = "[right]"

var _frequency: float = 16.0

@onready var final_score_value: RichTextLabel = %FinalScoreValue
@onready var rocks_destroyed_value: RichTextLabel = %RocksDestroyedValue
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	hide()
	restart_button.pressed.connect(_on_restart_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _process(_delta: float) -> void:
	# Make rich text labels pulse
	if visible:
		var time := Time.get_ticks_msec() / 1000.0
		var alpha := (sin(time * _frequency) + 1.25) * 0.75
		final_score_value.modulate = Color.from_hsv(1.0, 0.0, 1.0, alpha)
		rocks_destroyed_value.modulate = Color.from_hsv(1.0, 0.0, 1.0, alpha)


func update_score_label(value: int, max_score: int) -> void:
	var clamped_value: int = clampi(value, 0, max_score)
	final_score_value.text = RIGHT_BB_CODE + Utils.format_integer(clamped_value)


func update_rocks_destroyed_label(rocks_destroyed: int, max_rocks_destroyed: int) -> void:
	var clamped_value: int = clampi(rocks_destroyed, 0, max_rocks_destroyed)
	rocks_destroyed_value.text = RIGHT_BB_CODE + Utils.format_integer(clamped_value)


func focus_game_over() -> void:
	restart_button.call_deferred("grab_focus")


func _on_restart_game_button_pressed() -> void:
	hide()
	restart_game.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
