extends Node

class_name ItemManager

@export var tile_map : TileMapLayer
var tile_map_layers : Array[TileMapLayer]
@export var path_finder : Pathfinder
var item_prototypes = []
@export var blueprints : Array[Buildable]

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map_layers = [%Ground, %Shadow, %build, %construction, %data]
	load_food()
	load_resources()
	load_plants()
	spawn_objects()

func spawn_objects():
	for layer in tile_map_layers:
		for x in layer.get_used_rect().size.x:
			for y in layer.get_used_rect().size.y:
				var tile_position = Vector2i(
					x + layer.get_used_rect().position.x
					,y + layer.get_used_rect().position.y )
				var object_data = layer.get_cell_tile_data(tile_position)
				
				if object_data != null and object_data.get_custom_data("type"):
					spawn_item(object_data.get_custom_data("type"), tile_position)
				
	tile_map.data.enabled = false
	
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
	
func reserve_item(item, item_type : String):
	if item != null:
		item.remove_from_group(item_type)
		item.add_to_group("reserved")
	
func free_item(item, item_type : String):
	if item != null:
		item.remove_from_group("reserved")
		item.add_to_group(item_type)
	
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
	reserve_item(closestItem, item_type)
	return closestItem
		
func _dir_contents(path : String, file_extension: String):
	var dir = DirAccess.open(path)
	var files = []
	
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(file_extension):
			files.append(path + "/" + file_name)
	dir.list_dir_end()
	return files

func load_food():
	var path = "res://scenes/entities/food/"
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
	var path = "res://scenes/entities/resources/"
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
	var path = "res://scenes/entities/plants/"
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
