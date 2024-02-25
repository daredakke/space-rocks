class_name PlayerBullet
extends PoolItem


var speed: float = 500


func _process(delta) -> void:
	position += _direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("kill_plane"):
		destroy()
	
	if area.is_in_group("enemy"):
		EventBus.rock_destroyed.emit()
		destroy()
