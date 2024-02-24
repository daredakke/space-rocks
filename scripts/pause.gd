class_name Pause
extends Control


signal start_new_game
signal continue_game
signal quit_game
signal fullscreen_toggled

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var options_button: Button = %OptionsButton
@onready var options: Panel = %Options
@onready var music_volume_label: Label = %MusicVolumeLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_volume_label: Label = %SFXVolumeLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var fullscreen_toggle: CheckBox = %FullscreenToggle
@onready var options_close_button: Button = %OptionsCloseButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	fullscreen_toggle.pressed.connect(_on_fullscreen_toggle_pressed)
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


func _on_music_slider_value_changed(value: float) -> void:
	music_volume_label.text = str(floor(value * 100)) + "%"
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus, value < 0.05)


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = str(floor(value * 100)) + "%"
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus, value < 0.05)


func _on_fullscreen_toggle_pressed() -> void:
	fullscreen_toggled.emit()


func _on_options_close_button_pressed() -> void:
	options.hide()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
