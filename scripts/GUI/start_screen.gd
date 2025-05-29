extends Node2D


func _input(event):
	if event.is_action_pressed('move') or event.is_action_pressed('act'):
		get_tree().change_scene_to_file("res://scenes/maps/witchwood.tscn")
