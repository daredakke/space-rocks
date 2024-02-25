class_name Game
extends Node2D


const MAX_SCORE: int = 999999
const MAX_ROCKS_DESTROYED: int = 99999
const ROCK_SCORE_VALUE: int = 10
const NOISE_SHAKE_SPEED: float = 30.0
const SHAKE_STRENGTH: float = 8.25
const SHAKE_DECAY_RATE: float = 10

var _game_started: bool:
	set(new_value):
		_game_started = new_value
		
		if _game_started:
			stats.show()
		else:
			stats.hide()
var _game_paused: bool:
	set(new_value):
		_game_paused = new_value
		_handle_pause_state()
var _is_fullscreen: bool = false
var _score: int:
	set(new_value):
		_score = new_value
		
		stats.update_score_label(_score, MAX_SCORE)
		game_over.update_score_label(_score, MAX_SCORE)
var _noise_i: float = 0.0
var _shake_strength: float = 0.0
var _rocks_destroyed: int:
	set(new_value):
		_rocks_destroyed = new_value
		
		game_over.update_rocks_destroyed_label(_rocks_destroyed, MAX_ROCKS_DESTROYED)

@onready var audio_bus: AudioBus = %AudioBus
@onready var camera: Camera2D = %Camera
@onready var stats: Stats = %Stats
@onready var pause: Control = %Pause
@onready var game_over: GameOver = %GameOver
@onready var fade_out: FadeOut = %FadeOut
@onready var crosshair: Crosshair = %Crosshair
@onready var player: Player = %Player
@onready var player_spawn_point: Marker2D = %PlayerSpawnPoint
@onready var rock_spawner: RockSpawner = %RockSpawner
@onready var score_gain_rate: Timer = %ScoreGainRate
@onready var game_over_delay: Timer = %GameOverDelay
@onready var quit_game_delay: Timer = %QuitGameDelay
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)


func _ready() -> void:
	pause.start_new_game.connect(_start_new_game)
	pause.continue_game.connect(_continue_game)
	pause.quit_game.connect(_start_quit_game_delay_timer)
	pause.fullscreen_toggled.connect(_on_toggle_fullscreen)
	game_over.restart_game.connect(_start_new_game)
	game_over.quit_game.connect(_start_quit_game_delay_timer)
	score_gain_rate.timeout.connect(_gain_score)
	game_over_delay.timeout.connect(_game_over)
	quit_game_delay.timeout.connect(_quit_game)
	EventBus.rock_destroyed.connect(_increase_rock_destroyed_count)
	EventBus.shot_fired.connect(_player_shot_fired)
	EventBus.shot_reloaded.connect(_player_shot_reloaded)
	EventBus.player_died.connect(_player_died)
	
	rand.randomize()
	noise.seed = randi()
	noise.frequency = 0.5
	_game_started = false
	_game_paused = true
	stats.update_score_label(_score, MAX_SCORE)
	
	player.destroy()


func _process(delta: float) -> void:
	if not _game_started:
		return
	
	if Input.is_action_just_pressed("pause"):
		_game_paused = !_game_paused
	
	if not _game_paused:
		# Screen shake decay
		_shake_strength = lerp(_shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
		camera.offset = _get_noise_offset(delta)


func _on_node_added(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_button_hovered)
		node.focus_entered.connect(_button_hovered)
		node.pressed.connect(_button_pressed)
	
	if node is HSlider:
		node.mouse_entered.connect(_button_hovered)
		node.focus_entered.connect(_button_hovered)


func _button_hovered() -> void:
	audio_bus.play_button_hovered()


func _button_pressed() -> void:
	audio_bus.play_button_selected()


func _start_new_game() -> void:
	_game_started = true
	_game_paused = false
	_score = 0
	_rocks_destroyed = 0
	
	player.respawn(player_spawn_point.global_position)
	score_gain_rate.start()
	stats.toggle_shot_indicators(player.MAX_SHOTS)
	crosshair.randomise_rotation()
	rock_spawner.reset()
	rock_spawner.start_spawning()


func _continue_game() -> void:
	_game_paused = false


func _start_quit_game_delay_timer() -> void:
	quit_game_delay.start()


func _quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _game_over() -> void:
	game_over.show()
	game_over.focus_game_over()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	crosshair.hide()


func _handle_pause_state() -> void:
	get_tree().paused = _game_paused
	
	if _game_paused:
		pause.show()
		pause.focus_main_menu()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		crosshair.hide()
	else:
		pause.hide()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		crosshair.show()


func _gain_score() -> void:
	_score += 1


func _increase_rock_destroyed_count() -> void:
	_score += ROCK_SCORE_VALUE
	_rocks_destroyed += 1


func _player_shot_fired(shots_left: int) -> void:
	_apply_noise_shake(SHAKE_STRENGTH + randf_range(0.1, 1.0))
	
	stats.toggle_shot_indicators(shots_left)


func _player_shot_reloaded(shots_left: int) -> void:
	stats.toggle_shot_indicators(shots_left)


func _player_died() -> void:
	fade_out.play()
	rock_spawner.stop_spawning()
	_apply_noise_shake(SHAKE_STRENGTH * 2.5)
	rock_spawner.stop_spawning()
	score_gain_rate.stop()
	game_over_delay.start()


func _apply_noise_shake(strength: float) -> void:
	_shake_strength = strength


func _get_noise_offset(delta: float) -> Vector2:
	_noise_i += delta * NOISE_SHAKE_SPEED
	
	return Vector2(
		noise.get_noise_2d(1, _noise_i) * _shake_strength,
		noise.get_noise_2d(100, _noise_i) * _shake_strength
	)


func _on_toggle_fullscreen() -> void:
	_is_fullscreen = !_is_fullscreen
	
	if _is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ProjectSettings.set_setting("display/window/size/borderless", false)
