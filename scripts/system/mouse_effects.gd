extends Node2D

@export var sprite : Sprite2D

func _process(delta: float) -> void:
	if sprite.is_pixel_opaque(sprite.get_local_mouse_position()):
