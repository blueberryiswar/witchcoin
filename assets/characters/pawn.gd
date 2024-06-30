extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@export var path_finder : Pathfinder
@export var ground_grid  : TileMap
var current_id_path : Array[Vector2i]
var current_point_path : PackedVector2Array
var old_position : Vector2
var end_target_position : Vector2
var current_anim = "idle"
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("move") == false:
		return
	
	end_target_position = get_global_mouse_position()
	var id_path = path_finder.get_my_path(global_position, end_target_position)
	if(id_path.is_empty()) == false:
		current_id_path = id_path
		
		current_point_path = path_finder.get_my_points(global_position, end_target_position)
		
		
func _process(delta):
	if(is_moving):
		update_line()
		update_animation("walk")
	else:
		animation_player.stop()
		update_animation("idle")

func _physics_process(delta):
	if current_id_path.is_empty():
		is_moving = false
		return
	
	var target_position = ground_grid.map_to_local(current_id_path.front())
	if(target_position.x < global_position.x):
		scale = Vector2(-1.0,1.0)
	else:
		scale = Vector2(1.0,1.0)
	
	global_position = global_position.move_toward(target_position, 1)
	is_moving = true
	if global_position == target_position:
		current_id_path.pop_front()
		update_position()
		

func update_animation(name):
	if (current_anim == name):
		return
	animation_player.play(name)
	
func update_line():
	current_point_path = path_finder.get_my_points(global_position, end_target_position)
	for i in current_point_path.size():
			current_point_path[i] = current_point_path[i] + Vector2(8,8)
			
func update_position():
	path_finder.move_solid(old_position, global_position)
	old_position = global_position

