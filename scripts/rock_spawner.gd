class_name RockSpawner
extends Node2D


const BASE_ROCK_SPEED: int = 65
const SPAWN_DELAY: float = 2.0
const DIFFICULTY_INCREASE_DELAY: float = 6.0
const SPREAD: int = 15

var rocks_to_spawn: int = 1

@onready var rock_pool: Pool = %Pool
@onready var spawn_delay: Timer = %SpawnDelay
@onready var difficulty_increase_delay: Timer = %DifficultyIncreaseDelay


func _ready() -> void:
	spawn_delay.timeout.connect(_spawn_rock)
	difficulty_increase_delay.timeout.connect(_increase_difficulty)


func start_spawning() -> void:
	spawn_delay.start()
	difficulty_increase_delay.start()


func stop_spawning() -> void:
	spawn_delay.stop()
	difficulty_increase_delay.stop()


func reset() -> void:
	rocks_to_spawn = 1
	spawn_delay.wait_time = SPAWN_DELAY
	difficulty_increase_delay.wait_time = DIFFICULTY_INCREASE_DELAY
	
	for child in rock_pool.get_children():
		child.destroy()


func _spawn_rock() -> void:
	for i in rocks_to_spawn:
		var rock = rock_pool.get_item() as Rock
		rock.speed = BASE_ROCK_SPEED + rocks_to_spawn
		
		var rock_scale: float = randf_range(0.5, 1.5)
		rock.scale = Vector2(rock_scale, rock_scale)
		
		var x_pos: int = randi_range(5, 295)
		var y_pos: int = randi_range(-130, -15)
		var angle: float = deg_to_rad((randf_range(-SPREAD, SPREAD)))
		var dir := Vector2.DOWN.rotated(angle).normalized()
		rock.spawn(Vector2(x_pos, y_pos), dir)


func _increase_difficulty() -> void:
	rocks_to_spawn += 1
	spawn_delay.wait_time = clampf(spawn_delay.wait_time - 0.1, 0.1, 5)
	difficulty_increase_delay.wait_time += 1
