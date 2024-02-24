class_name Explosion
extends Sprite2D


var direction: Vector2
var speed: float
var animation_speed_scale: float = 1
var expansion_rate: float = 0.008

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.speed_scale = animation_speed_scale
	animation_player.play("fade_out")


func _process(delta: float) -> void:
	position += direction * speed * delta
	scale.x += expansion_rate
	scale.y += expansion_rate
	speed -= 0.5


func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
