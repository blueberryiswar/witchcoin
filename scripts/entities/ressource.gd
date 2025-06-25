extends Item

class_name Ressource

enum RessourceType {Wood = 0, Stone = 1}

@export var ressource_type : RessourceType

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group(item_name)
	
func on_rightclick():
	var task_managers = get_tree().get_nodes_in_group("task_manager")
	for task_manager in task_managers:
		task_manager.add_task(Task.TaskType.Store, self)
