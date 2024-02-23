extends Sprite2D


@onready var _rotation_speed: float = 0.2


func _process(delta: float) -> void:
	rotation += _rotation_speed * delta
