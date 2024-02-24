class_name AudioBus
extends Node


@onready var rock_destroyed: AudioStreamPlayer2D = %RockDestroyed
@onready var shot_fired: AudioStreamPlayer2D = %ShotFired
@onready var shot_reloaded: AudioStreamPlayer2D = %ShotReloaded
@onready var player_died: AudioStreamPlayer2D = %PlayerDied
@onready var button_selected: AudioStreamPlayer2D = %ButtonSelected


func _ready() -> void:
	EventBus.rock_destroyed.connect(_play_rock_destroyed)
	EventBus.shot_fired.connect(_play_shot_fired)
	EventBus.shot_reloaded.connect(_play_shot_reloaded)
	EventBus.player_died.connect(_play_player_died)
	EventBus.player_died.connect(_play_rock_destroyed)
	rock_destroyed.finished.connect(_on_rock_destroyed_finished)
	shot_fired.finished.connect(_on_shot_fired_finished)


func play_button_selected() -> void:
	button_selected.play()


func _play_rock_destroyed(_score: int) -> void:
	rock_destroyed.play()


func _play_shot_fired(_shots_left: int) -> void:
	shot_fired.play()


func _play_shot_reloaded(_shots_left: int) -> void:
	shot_reloaded.play()


func _play_player_died() -> void:
	player_died.play()


func _on_rock_destroyed_finished() -> void:
	_modulate_pitch(rock_destroyed)


func _on_shot_fired_finished() -> void:
	_modulate_pitch(shot_fired)


func _modulate_pitch(audio_player: AudioStreamPlayer2D) -> void:
	audio_player.pitch_scale = randf_range(0.95, 1.05)
