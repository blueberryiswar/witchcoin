extends Node2D

class_name Clickable_Area

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("act"):
		print("rightclick")
			#if get_parent().has_method("on_rightclick"):
			#	get_parent().on_rightclick()
	elif event.is_action_pressed("move"):
		print("leftclick")
			#if get_parent().has_method("on_leftclick"):
			#	get_parent().on_leftclick()
