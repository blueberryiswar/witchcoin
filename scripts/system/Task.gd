extends Node

class_name Task

enum TaskType {BaseTask, FindItem, WalkTo, Pickup, Eat, Manipulate, Harvest, Carry, Drop, Store}

var task_name : String
var task_type : TaskType = TaskType.BaseTask

var sub_tasks = []
var current_sub_task : int = 0

var target_item : Item
var has_item : bool = false
var used_item : bool = false
var target_item_type : String

func is_finished() -> bool:
	return current_sub_task == len(sub_tasks)

func finish():
	current_sub_task = len(sub_tasks)
	
func get_current_sub_task():
	return sub_tasks[current_sub_task]
	
func on_finish_sub_task():
	current_sub_task += 1
	
func on_found_item(item):
	on_finish_sub_task()
	get_current_sub_task().target_item = item
	get_current_sub_task().has_item = true
	
func on_reached_destination():
	var item = get_current_sub_task().target_item
	on_finish_sub_task()
	if item != null:
		get_current_sub_task().target_item = item
		get_current_sub_task().has_item = true
		
func on_used_item():
	get_current_sub_task().has_item = false

func init_find_and_eat_food():
	task_name = "Find and Eat Food"
		
	var sub_task = Task.new()
	sub_task.task_type = TaskType.FindItem
	sub_task.target_item_type = "food"
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.WalkTo
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Pickup
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Eat
	sub_tasks.append(sub_task)
	
func init_harvest_plant(target):
	task_name = "Harvest plant"
	var sub_task = null
	
	if(target == null):
		sub_task = Task.new()
		sub_task.task_type = TaskType.FindItem
		sub_task.target_item_type = "Plant"
		sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.WalkTo
	sub_task.target_item = target
	sub_task.has_item = true
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Harvest
	sub_tasks.append(sub_task)
	
func init_haul_item(target, storage):
	task_name = "Hauling Items"
	
	var sub_task = Task.new()
	sub_task.task_type = TaskType.WalkTo
	sub_task.target_item = target
	sub_task.has_item = true
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Pickup
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.WalkTo
	sub_task.target_item = storage
	sub_task.has_item = true
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Store
	
	
