class_name Player
extends CharacterBody2D


signal shot_fired(shots_left: int)
signal shot_reloaded(shots_left: int)
signal player_died

const ANGULAR_SPEED: float = TAU * 2
const MAX_SHOTS: int = 3

@export_range(100, 1000) var player_speed: float = 400.0
@export_range(0.1, 2.0) var shot_fire_rate: float = 0.33
@export_range(0.1, 2.0) var reload_rate: float = 1.0

var is_alive: bool = true
var player_direction: Vector2

var _target_angle: float
var _dead_position := Vector2(150, -50)
var _shots_left: int = MAX_SHOTS

@onready var bullet_spawn: Marker2D = %BulletSpawn
@onready var hitbox_sprite: Sprite2D = %HitboxSprite
@onready var bullet_pool: Pool = %BulletPool
@onready var fire_rate: Timer = %FireRate
@onready var reload: Timer = %Reload


func _ready() -> void:
	fire_rate.wait_time = shot_fire_rate
	reload.wait_time = reload_rate
	
	reload.timeout.connect(_on_reloaded)


func _process(delta: float) -> void:
	if not is_alive:
		return
	
	# Movement
	var move_speed: float
	
	if Input.is_action_pressed("focus"):
		move_speed = player_speed * 0.5
		hitbox_sprite.show()
	else:
		move_speed = player_speed
		hitbox_sprite.hide()
	
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * move_speed
	
	move_and_slide()
	
	# Rotation
	_target_angle = (get_global_mouse_position() - position).angle()
	var angle_diff: float = wrapf(_target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
	
	# Firing
	if Input.is_action_pressed("fire") and fire_rate.is_stopped() and _shots_left > 0:
		var player_dir: Vector2 = (get_global_mouse_position() - position).normalized()
		
		var bullet = bullet_pool.get_item() as PlayerBullet
		bullet.spawn(global_position, player_dir)
		
		_shots_left -= 1
		
		shot_fired.emit(_shots_left)
		fire_rate.start()
		reload.start()


func respawn(pos: Vector2) -> void:
	is_alive = true
	global_position = pos
	
	set_process(true)


func destroy() -> void:
	is_alive = false
	global_position = _dead_position
	
	set_process(false)


func _on_reloaded() -> void:
	if _shots_left < MAX_SHOTS:
		_shots_left += 1
		
		shot_reloaded.emit(_shots_left)
		reload.start()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		destroy()
		player_died.emit()
