class_name Game
extends Node2D


const NOISE_SHAKE_SPEED: float = 30.0
const SHAKE_STRENGTH: float = 8.25
const SHAKE_DECAY_RATE: float = 10

var _game_started: bool = false
var _game_paused: bool = false
var _score: int = 0
var _noise_i: float = 0.0
var _shake_strength: float = 0.0

@onready var camera: Camera2D = %Camera
@onready var player: Player = %Player
@onready var player_spawn_point: Marker2D = %PlayerSpawnPoint
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()


func _ready() -> void:
	EventBus.shot_fired.connect(_player_shot_screen_shake)
	
	rand.randomize()
	noise.seed = randi()
	noise.frequency = 0.5
	
	_start_new_game()


func _process(delta: float) -> void:
	if not _game_started:
		return
	
	if Input.is_action_just_pressed("pause"):
		_game_paused = !_game_paused
	
	if not _game_paused:
		# Screen shake decay
		_shake_strength = lerp(_shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
		camera.offset = _get_noise_offset(delta)


func _start_new_game() -> void:
	_game_started = true
	_score = 0
	
	player.respawn(player_spawn_point.global_position)


func _player_shot_screen_shake() -> void:
	_apply_noise_shake(SHAKE_STRENGTH + randf_range(0.1, 1.0))


func _apply_noise_shake(strength: float) -> void:
	_shake_strength = strength


func _get_noise_offset(delta: float) -> Vector2:
	_noise_i += delta * NOISE_SHAKE_SPEED
	
	return Vector2(
		noise.get_noise_2d(1, _noise_i) * _shake_strength,
		noise.get_noise_2d(100, _noise_i) * _shake_strength
	)
