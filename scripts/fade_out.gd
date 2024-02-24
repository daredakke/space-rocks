class_name FadeOut
extends ColorRect


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()


func play() -> void:
	show()
	animation_player.play("fade_out")


func _on_animation_finished(_anim_name: StringName) -> void:
	hide()
