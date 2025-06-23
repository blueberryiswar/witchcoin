extends Node

class_name TaskManager

@onready var pawn = $'..'
var task_queue = []

func request_task():
	if(pawn.hunger >= 1.0):
		var task = Task.new()
		task.init_find_and_eat_food()
		return task
	if !pawn.active and !pawn.is_moving and pawn.recreation_need >= 1.0:
		var task = Task.new()
		task.going_for_a_walk()
		pawn.recreation = true
		return task
	if(len(task_queue) > 0):
		return task_queue.pop_front()

func add_task(task_type : Task.TaskType, target : Node = null):
	if(!pawn.controllable): return
	
	var task = Task.new()
	pawn.recreation = false
	
	if(task_type == Task.TaskType.Harvest):
		task.init_harvest_plant(target)
	if(task_type == Task.TaskType.Store):
		task.init_haul_item(target)
	if(task_type == Task.TaskType.Construct):
		task.building_structure(target)
	
		
	task_queue.append(task)
		
