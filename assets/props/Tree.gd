extends Sprite2D

var age : int = 0
var harvest_item : Item
var harvest_difficulty = 1
var progress = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var age = rng.randi_range(0, 3)
	frame = age
	
func set_harvest_item(item):
	harvest_item = item
	
func interact(delta):
	progress += 1 / harvest_difficulty * delta
	if progress >= 1.0:
		drop_item
		return true
	else:
		return false
	
func drop_item():
	var new_item = harvest_item.instantiate()
	get_tree().add_child(new_item)
	new_item.global_position = global_position
	frame = 4

