extends Node

@export var sprite : Sprite2D

func _input(event):
	if event.is_action_pressed("act"):
		if sprite.is_pixel_opaque(sprite.get_local_mouse_position()):
			if get_parent().has_method("on_click"):
				get_parent().on_click()
	elif event.is_action_pressed("move"):
		if sprite.is_pixel_opaque(sprite.get_local_mouse_position()):
			if get_parent().has_method("on_rightclick"):
				get_parent().on_rightclick()
