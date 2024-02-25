class_name Pool
extends Node


@export_range(1, 100) var initial_spawn: int = 10
@export var node: PackedScene


func _ready() -> void:
	for i in initial_spawn:
		var item := node.instantiate() as PoolItem
		item.visible = false
		add_child(item, true)


func get_item() -> PoolItem:
	var item = get_child(0) as PoolItem
	
	# Return new item if all current items are active
	if (item.active):
		var new_item := node.instantiate() as PoolItem
		add_child(new_item, true)
		return new_item
	
	return item
