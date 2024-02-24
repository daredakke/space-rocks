class_name PoolItem
extends Area2D


var active: bool = false

var _direction: Vector2


func _ready() -> void:
	visible = false
	monitoring = false
	monitorable = false
	set_process(false)


func spawn(pos: Vector2, dir: Vector2) -> void:
	active = true
	visible = true
	monitoring = true
	monitorable = true
	set_process(true)
	get_parent().move_child(self, -1)
	
	global_position = pos
	_direction = dir


func destroy() -> void:
	active = false
	visible = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_process(false)
	get_parent().move_child(self, 0)
