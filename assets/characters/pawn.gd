extends Node2D

@onready var animation_player = $AnimationPlayer
@export var path_finder : Pathfinder
@export var ground_grid  : TileMap
var current_id_path : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("move") == false:
		return
	
	var id_path = path_finder.get_my_path(global_position, get_global_mouse_position())
	print(id_path)
	if(id_path.is_empty()) == false:
		current_id_path = id_path

func _physics_process(delta):
	if current_id_path.is_empty():
		return
	
	var target_position = ground_grid.map_to_local(current_id_path.front())
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		current_id_path.pop_front()
