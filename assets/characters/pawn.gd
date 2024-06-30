extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@export var path_finder : Pathfinder
@export var ground_grid  : TileMap
@export var item_manager : ItemManager
var current_id_path : Array[Vector2i]
var current_point_path : PackedVector2Array
var old_position : Vector2
var end_target_position : Vector2
var current_anim = "idle"
var is_moving = false
var in_hand : Item = null
var hunger : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("act"):
		find_food()
	if event.is_action_pressed("move"):
		move_to(get_global_mouse_position())

func _process(delta):
	if(is_moving):
		update_line()
		update_animation("walk")
	else:
		animation_player.stop()
		update_animation("idle")
		
	if(in_hand != null):
		in_hand.global_position = global_position
	
	hunger += delta * 0.01

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

func move_to(position : Vector2):
	end_target_position = position
	var id_path = path_finder.get_my_path(global_position, end_target_position)
	if(id_path.is_empty()) == false:
		current_id_path = id_path
		current_point_path = path_finder.get_my_points(global_position, end_target_position)

func pick_up(target_item : Item):
	item_manager.remove_item(target_item)
	$Hand.add_child(target_item)
	in_hand = target_item

func eat():
	if(in_hand.item_type == Item.ItemType.FOOD):
		hunger -= in_hand.nutrition
		in_hand.count -= 1
		if(in_hand.count > 0):
			drop_item()
		else:
			in_hand.queue_free()
			in_hand = null
			
	else:
		drop_item()
		
func drop_item():
	$Hand.remove_child(in_hand)
	item_manager.add_child(in_hand)
	in_hand = null
		
	
func find_food():
	var item = item_manager.find_nearest_item(global_position,"food")
	if item == null: return false
	move_to(item.global_position)
	return true

func find_nearest_item(item_type : String):
	var item = item_manager.find_nearest_item(global_position,"food")
	return item

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

