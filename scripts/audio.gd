class_name AudioBus
extends Node


@onready var rock_destroyed: AudioStreamPlayer2D = %RockDestroyed
@onready var shot_fired: AudioStreamPlayer2D = %ShotFired
@onready var shot_reloaded: AudioStreamPlayer2D = %ShotReloaded
@onready var player_died: AudioStreamPlayer2D = %PlayerDied
@onready var button_hovered: AudioStreamPlayer2D = %ButtonHovered
@onready var button_selected: AudioStreamPlayer2D = %ButtonSelected
@onready var game_music: AudioStreamPlayer2D = %GameMusic
@onready var menu_music: AudioStreamPlayer2D = %MenuMusic


func _ready() -> void:
	EventBus.rock_destroyed.connect(_play_rock_destroyed)
	EventBus.shot_fired.connect(_play_shot_fired)
	EventBus.shot_reloaded.connect(_play_shot_reloaded)
	EventBus.player_died.connect(_stop_game_music)
	EventBus.player_died.connect(_play_player_died)
	game_music.finished.connect(play_game_music)
	menu_music.finished.connect(play_menu_music)
	rock_destroyed.finished.connect(_on_rock_destroyed_finished)
	shot_fired.finished.connect(_on_shot_fired_finished)


func play_game_music() -> void:
	game_music.play()


func play_menu_music() -> void:
	menu_music.play()


func stop_menu_music() -> void:
	menu_music.stop()


func play_button_selected() -> void:
	button_selected.play()


func play_button_hovered() -> void:
	if not button_selected.playing:
		button_hovered.play()


func _stop_game_music() -> void:
	game_music.stop()


func _play_rock_destroyed() -> void:
	rock_destroyed.play()


func _play_shot_fired(_shots_left: int) -> void:
	shot_fired.play()


func _play_shot_reloaded(_shots_left: int) -> void:
	shot_reloaded.play()


func _play_player_died() -> void:
	player_died.play()
	rock_destroyed.play()


func _on_rock_destroyed_finished() -> void:
	_modulate_pitch(rock_destroyed)


func _on_shot_fired_finished() -> void:
	_modulate_pitch(shot_fired)


func _modulate_pitch(audio_player: AudioStreamPlayer2D) -> void:
	audio_player.pitch_scale = randf_range(0.95, 1.05)
