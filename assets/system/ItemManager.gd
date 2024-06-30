extends Node

class_name ItemManager

@export var tile_map : TileMap
@export var path_finder : Pathfinder
var food_prototypes = []
var resource_prototypes = []


# Called when the node enters the scene tree for the first time.
func _ready():
	load_food()
	load_resources()
	
	spawn_item(food_prototypes[0], Vector2i(10,10))
	spawn_item(food_prototypes[0], Vector2i(15,20))
	spawn_item(food_prototypes[1], Vector2i(18,10))
	
	add_tree_resource()

func spawn_item(item, pos : Vector2i):
	var new_item = item.instantiate()
	add_child(new_item)
	new_item.position = tile_map.map_to_local(pos)
	
func remove_item(target_item):
	remove_child(target_item)
	
func find_nearest_item(my_position: Vector2, item_type : String):
	var closestItem : Item = null
	var distance = 9999999
	
	var items_in_world = get_tree().get_nodes_in_group(item_type)
	for item in items_in_world:
		var distance_new = path_finder.get_my_path(my_position, item.global_position).size()
		if(distance_new < distance):
			distance = distance_new
			closestItem = item
			print(distance, closestItem)
	return closestItem

func load_food():
	var path = "res://assets/items/food"
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			food_prototypes.append(load(path + "/" + file_name))
			print(file_name)
	dir.list_dir_end()
	
func load_resources():
	var path = "res://assets/items/resources"
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			resource_prototypes.append(load(path + "/" + file_name))
			print(file_name)
	dir.list_dir_end()
	
func add_tree_resource():
	var trees_in_world = get_tree().get_nodes_in_group("tree")
	for tree in trees_in_world:
		tree.add_harvest_item(resource_prototypes[0])
