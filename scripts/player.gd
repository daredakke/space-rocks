class_name Player
extends CharacterBody2D


const ANGULAR_SPEED: float = TAU * 2

@export_range(100, 1000) var player_speed: float = 500.0
@export_range(0.1, 2.0) var shot_fire_rate: float = 0.33

var is_alive: bool = true
var player_direction: Vector2

var _target_angle: float
var _dead_position := Vector2(150, -50)

@onready var bullet_spawn: Marker2D = %BulletSpawn
@onready var hitbox_sprite: Sprite2D = %HitboxSprite
@onready var fire_rate: Timer = %FireRate
@onready var reload: Timer = %Reload


func _ready() -> void:
	fire_rate.wait_time = shot_fire_rate


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
	
	if Input.is_action_pressed("fire") and fire_rate.is_stopped():
		var player_dir: Vector2 = (get_global_mouse_position() - position).normalized()
		
		fire_rate.start()
