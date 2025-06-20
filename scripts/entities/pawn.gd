extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@export var path_finder : Pathfinder
@export var ground_grid  : TileMapLayer
@export var item_manager : ItemManager
@export var pawn_name : String = "Bob"
@export var clothes : int = 19
@export var pants : int = 2
@export var hair : int = 25
@export var hats : int = 40
@export var beard : int = 2 #32 - 39
var current_id_path : Array[Vector2i]
var current_point_path : PackedVector2Array
var old_position : Vector2
var end_target_position : Vector2i
var current_anim = "idle"
var is_moving = false
var in_hand : Item = null
var hunger : float = 0.0
var recreation_need = 0.0
var recreation = false
var interaction_target : Item = null
@export var active : bool = false
@export var controllable : bool = false

var current_pos : Vector2i

signal active_pawn_changed()
signal abort_task()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pawn")
	animation_player.play("idle")
	$Body/Hair.frame = hair
	$Body/Clothes.frame = clothes
	$Body/Beard.frame = beard
	$Body/Pants.frame = pants
	$Body/Hats.frame = hats

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if !active: return
	if event.is_action_pressed("act"):
		abort_task.emit()
		move_to(get_global_mouse_position())
	if event.is_action_pressed("move"):
		pass

func _process(delta):
	update_current_pos()
	if(is_moving):
		hunger += delta * 0.01 # moving makes hungry :D
		if(active):
			update_line()
		update_animation("walk")
	else:
		animation_player.stop()
		update_animation("idle")
		
	if(in_hand != null):
		in_hand.global_position = global_position
		
	if(interaction_target != null):
		if(interaction_target.interact(delta)):
			interaction_target = null
	
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

func move_to(pos : Vector2):
	end_target_position = pos
	var id_path = path_finder.get_my_path(global_position, end_target_position)
	if(id_path.is_empty()) == false:
		current_id_path = id_path
		current_point_path = path_finder.get_my_points(global_position, end_target_position)

func update_current_pos():
	var pos_temp : Vector2i = floor(global_position/16)
	var target_temp : Vector2i = floor(end_target_position/16)
	if pos_temp == current_pos:
		if !path_finder.astar_grid.is_point_solid(current_pos):
			path_finder.astar_grid.set_point_solid(current_pos,true)
			path_finder.astar_grid.update()
			#print("solid gesetzt: " + str(current_pos))	
		return
	if current_pos != null:
		#print("solid entfernt: " + str(current_pos))
		path_finder.astar_grid.set_point_solid(current_pos,false)
	current_pos = pos_temp
	if end_target_position != Vector2i.ZERO:
		move_to(end_target_position)
	path_finder.astar_grid.set_point_solid(current_pos,true)
	path_finder.astar_grid.update()
	print("solid gesetzt: " + str(current_pos))	

func pick_up(target_item : Item):
	item_manager.remove_item(target_item)
	$Hand.add_child(target_item)
	in_hand = target_item
	
func interact(target_item):
	interaction_target = target_item

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
	var item = item_manager.find_nearest_item(global_position,item_type)
	return item

func update_animation(anim_name):
	if (current_anim == anim_name):
		return
	animation_player.play(anim_name)

func update_line():
	current_point_path = path_finder.get_my_points(global_position, end_target_position)
	for i in current_point_path.size():
			current_point_path[i] = current_point_path[i] + Vector2(8,8)

func update_position():
	path_finder.move_solid(old_position, global_position)
	old_position = global_position
	
func on_leftclick():
	if !Input.is_action_pressed("mult_select"):
		if not active and not controllable:
			var pawns = get_tree().get_nodes_in_group("Pawn")
			for pawn in pawns:
				pawn.active = false
				pawn.controllable = false
		active = not active
		controllable = not controllable
	else:
		active = not active
		controllable = not controllable
	active_pawn_changed.emit()
	
func random_target_position():
	var a = choose([-1,-2,-3,1,2,3])
	var b = choose([-1,-2,-3,1,2,3])
	var c = (current_pos + Vector2i(a,b))
	print(pawn_name + " target: " + str(c))
	return c
	
func choose(array: Array[int]):
	if !array.is_empty():
		array.shuffle()
		return array.front()
