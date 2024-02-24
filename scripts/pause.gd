class_name Pause
extends Control


signal start_new_game
signal continue_game
signal quit_game
signal set_fullscreen(state: bool)

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var options: Panel = %Options
@onready var options_close_button: Button = %OptionsCloseButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	options_close_button.pressed.connect(_on_options_close_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	continue_button.hide()
	options.hide()


func _on_new_game_button_pressed() -> void:
	continue_button.show()
	start_new_game.emit()


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_options_button_pressed() -> void:
	options.show()


func _on_quit_button_pressed() -> void:
	quit_game.emit()


func _on_options_close_button_pressed() -> void:
	options.hide()
