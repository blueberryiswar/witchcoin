extends Plant

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group("Tree")
	var rng = RandomNumberGenerator.new()
	var age = rng.randi_range(0, 3)
	frame = age

func drop_item():
	super.drop_item()
	frame = 4
