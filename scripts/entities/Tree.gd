extends Plant

var age

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group("Tree")
	var rng = RandomNumberGenerator.new()
	age = rng.randi_range(0, 3)
	frame = age
	material.set_shader_parameter("shake_intensity", 0.0)

func drop_item():
	super.drop_item()
	frame = 4

func play_interaction_animation():
	material.set_shader_parameter("shake_intensity", 1.0)
	
func stop_interaction_animation():
	material.set_shader_parameter("shake_intensity", 0.0)
