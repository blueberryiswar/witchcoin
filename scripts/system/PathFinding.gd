class_name Pathfinder
extends Node


var astar_grid

@export var tile_map : TileMapLayer
@export var player : Node2D

# Called when the no de enters the scene tree for the first time.
func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x
				,y + tile_map.get_used_rect().position.y )
			var build_data = tile_map.build.get_cell_tile_data(tile_position)
			var ground_data = tile_map.ground.get_cell_tile_data(tile_position)
			
			if build_data != null and build_data.get_custom_data("solid") or ground_data != null and ground_data.get_custom_data("solid"):
				astar_grid.set_point_solid(tile_position)

func get_my_path(start, to):
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(start), 
		tile_map.local_to_map(to),
		true
		).slice(1)
	return id_path

func get_my_points(start, to):
	var point_path = astar_grid.get_point_path(
		tile_map.local_to_map(start), 
		tile_map.local_to_map(to),
		true
		).slice(1)
	return point_path

func move_solid(old_position, new_position):
	if(old_position):
		astar_grid.set_point_solid(tile_map.local_to_map(old_position), false)
	astar_grid.set_point_solid(tile_map.local_to_map(new_position))

func find_nearest_storage(my_position: Vector2):
	var closestStorage : Vector2
	var distance = 9999999	
	var storages_in_world = []
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x
				,y + tile_map.get_used_rect().position.y )
			var build_data = tile_map.build.get_cell_tile_data(tile_position)
			if build_data != null:
				if build_data.terrain_set == 2:
					storages_in_world.append(tile_position)
	if !storages_in_world.is_empty():
		for storage in storages_in_world:
			storage = tile_map.gridToGlobalPos(storage)
			var distance_new = get_my_path(my_position, storage).size()
			if(distance_new < distance):
				distance = distance_new
				closestStorage = storage
	return closestStorage
