class_name Pathfinder
extends Node


var astar_grid
@export var my_ground_grid : TileMap
@export var my_buildable_grid : TileMap
@export var player : Node2D

const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

# Called when the no de enters the scene tree for the first time.
func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = my_ground_grid.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar_grid.update()

func get_my_path(start, to):
	var id_path = astar_grid.get_id_path(
		my_ground_grid.local_to_map(start), 
		my_ground_grid.local_to_map(to)
		).slice(1)
	return id_path
	


