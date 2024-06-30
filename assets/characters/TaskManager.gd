extends Node

class_name TaskManager

@onready var pawn = $'..'

func request_task():
	if(pawn.hunger >= 1.0):
		var task = Task.new()
		task.init_find_and_eat_food()
		return task
