class_name Rock
extends PoolItem


var direction: Vector2
var speed: float = 70
var speed_variance: float = 15

var _rotation_speed: float = randf_range(0.2, 0.6)

@onready var rock_sprite: Sprite2D = $RockSprite


func _ready() -> void:
	rock_sprite.frame = randi() % 4
	speed += randf_range(0, speed_variance)
	rotation_degrees = randf_range(0, 360)
	
	if randf() > 0.5:
		_rotation_speed = -_rotation_speed


func _process(delta):
	position += _direction * speed * delta
	rotation += _rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("kill_plane") or area.is_in_group("player_bullet"):
		destroy()
