extends Node

class_name Task

enum TaskType {BaseTask, FindItem, WalkTo, 
Pickup, Eat, Manipulate, Harvest, Carry, Drop, Store, WalkToRandom, WalkToStorage, Construct,
Build}

var task_name : String
var task_type : TaskType = TaskType.BaseTask

var sub_tasks = []
var current_sub_task : int = 0

var target_item : Node
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
	
func init_haul_item(target):
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
	sub_task.task_type = TaskType.WalkToStorage
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Store
	sub_tasks.append(sub_task)
	
func going_for_a_walk():
	task_name = "Going for a Walk"
		
	var sub_task = Task.new()
	sub_task.task_type = TaskType.WalkToRandom
	sub_tasks.append(sub_task)
		
func building_structure(target):
	task_name = "Building Structure"
	
	var structure = target
	
	var a = target.requierements
	var b = target.requierementsReady
		
	if a != b:
			
		var item = target.getNeededItem()
		var sub_task = Task.new()
		
		sub_task.task_type = TaskType.FindItem
		sub_task.target_item_type = item
		sub_tasks.append(sub_task)
		
		sub_task = Task.new()
		sub_task.task_type = TaskType.WalkTo
		sub_tasks.append(sub_task)
		
		sub_task = Task.new()
		sub_task.task_type = TaskType.Pickup
		sub_tasks.append(sub_task)
		
		sub_task = Task.new()
		sub_task.task_type = TaskType.WalkTo
		sub_task.target_item = structure
		sub_tasks.append(sub_task)
		
		sub_task = Task.new()
		sub_task.task_type = TaskType.Store
		sub_tasks.append(sub_task)
		
		target.updateRequierements()
		
		a = target.requierements
		b = target.requierementsReady
	
	var sub_task = Task.new()
	sub_task.task_type = TaskType.WalkTo
	sub_tasks.append(sub_task)
	
	sub_task = Task.new()
	sub_task.task_type = TaskType.Build
	sub_tasks.append(sub_task)
