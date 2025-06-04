extends Node

@export var sprite : Sprite2D

func _input(event):
	if event.is_action_pressed("act"):
		if sprite.is_pixel_opaque(sprite.get_local_mouse_position()):
			get_parent().on_click()
