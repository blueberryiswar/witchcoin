extends Node

class_name ItemManager

@export var tile_map : TileMap
@export var path_finder : Pathfinder
var item_prototypes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_food()
	load_resources()
	load_plants()
	spawn_objects()
	
	spawn_item("res://assets/items/food/Berries.tscn", Vector2i(10,10))
	spawn_item("res://assets/items/food/Berries.tscn", Vector2i(15,20))
	spawn_item("res://assets/items/food/Fruit.tscn", Vector2i(18,10))
	spawn_item("res://assets/items/plants/BerryBush.tscn", Vector2(20,21))
	spawn_item("res://assets/items/plants/BerryBush.tscn", Vector2(28,25))
	spawn_item("res://assets/items/plants/BerryBush.tscn", Vector2(32,17))
	

func spawn_objects():
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x
				,y + tile_map.get_used_rect().position.y )
			var object_data = tile_map.get_cell_tile_data(3,tile_position)
			
			if object_data != null and object_data.get_custom_data("type"):
				spawn_item(object_data.get_custom_data("type"), tile_position)
				
	tile_map.set_layer_enabled(3, false)

func spawn_item(item_path : String, pos : Vector2i):
	var item = get_item_by_name(item_path)
	if(item == null): return
	add_child(item)
	item.position = tile_map.map_to_local(pos)
	
func spawn_item_global(item_path : String, pos : Vector2):
	var item = get_item_by_name(item_path)
	if(item == null): return
	tile_map.add_child(item)
	item.position = pos
	
func remove_item(target_item):
	tile_map.remove_child(target_item)
	
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
			item_prototypes.append(load(path + "/" + file_name))
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
			item_prototypes.append(load(path + "/" + file_name))
			print(file_name)
	dir.list_dir_end()
	
func load_plants():
	var path = "res://assets/items/plants"
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			item_prototypes.append(load(path + "/" + file_name))
			print(file_name)
	dir.list_dir_end()
	
func get_item_by_name(item_path):
	for item in item_prototypes:
		if(item.get_path() == item_path):
			var new_item = item.instantiate()
			return new_item
	print("Could not find item with path: " + item_path)
	return null
