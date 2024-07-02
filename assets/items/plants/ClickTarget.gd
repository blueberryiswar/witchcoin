extends Area2D

func _input(event):
	if event.is_action_pressed("act"):
		get_parent().on_click()
		
		
