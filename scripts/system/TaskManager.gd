extends Node

class_name TaskManager

@onready var pawn = $'..'
var task_queue = []

func request_task():
	if(pawn.hunger >= 1.0):
		var task = Task.new()
		task.init_find_and_eat_food()
		return task
	#if pawn.hunger < 0.5:
		#var task = Task.new()
		#task.going_for_a_walk()
		#return task
	if(len(task_queue) > 0):
		return task_queue.pop_front()

func add_task(task_type : Task.TaskType, target : Item = null):
	if(!pawn.controllable): return
	
	var task = Task.new()
	
	if(task_type == Task.TaskType.Harvest):
		task.init_harvest_plant(target)
		
	task_queue.append(task)
		
