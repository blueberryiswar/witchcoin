extends Item

class_name Plant

@export var harvestable_item : String = ""
var harvest_difficulty = 1
var progress = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Plant")
	
func interact(delta) -> bool:
	progress += 1.0 / harvest_difficulty * delta
	if progress >= 1.0:
		drop_item()
		return true
	else:
		return false
		
func on_rightclick():
	var task_managers = get_tree().get_nodes_in_group("task_manager")
	for task_manager in task_managers:
		task_manager.add_task(Task.TaskType.Harvest, self)
	
	
func drop_item():
	item_manager.spawn_item_global(harvestable_item, position)
	
func is_finished():
	return progress >= 1.0

func remove():
	queue_free()
