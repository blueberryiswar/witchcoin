extends Item

class_name Food

enum FoodType {OMNIVORE = 0, VEGETARIAN = 1, CARNIVORE = 2}
enum FoodQuality {RAW = 0, SIMPLE = 1, GOOD = 2, FANCY = 3}

@export var nutrition = 1.0
@export var food_type : FoodType
@export var food_quality : FoodQuality

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group("food")
	
func on_rightclick():
	var task_managers = get_tree().get_nodes_in_group("task_manager")
	for task_manager in task_managers:
		task_manager.add_task(Task.TaskType.Store, self)
