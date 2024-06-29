class_name Pathfinder
extends Node


var astar_grid
@export var tile_map : TileMap
@export var player : Node2D

const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

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
			var build_data = tile_map.get_cell_tile_data(2,tile_position)
			var ground_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if build_data != null and build_data.get_custom_data("solid") or ground_data != null and ground_data.get_custom_data("solid"):
				astar_grid.set_point_solid(tile_position)

func get_my_path(start, to):
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(start), 
		tile_map.local_to_map(to)
		).slice(1)
	return id_path
	


