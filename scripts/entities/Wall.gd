extends Node

class_name Wall

@export var requierements = {"Wood" : 1}
var requierementsReady = {"Wood" : 0}

@export var tileMapIndex : Vector2i
@export var placingMode : UI.PlacingMode
@export var terrain : UI.Terrain = UI.Terrain.WALL
@export var tile_id : UI.Tile_id = UI.Tile_id.WALL
@export var buildDifficulty : float = 1
@export var category : Buildable.BuildCategory = Buildable.BuildCategory.STRUCTURE

var buildProgress : float = 0

var global_position : Vector2
var pos : Vector2i

var tilemapManager = null

func getNeededItem() -> String:
	var neededItems = requierements.keys()
	var neededItem = neededItems[0]
	return neededItem
	
func updateRequierements():
	requierements.Wood += 1

func tryBuild(amount : float) -> bool:
	buildProgress += amount * 1/buildDifficulty
	pos = tilemapManager.globalToGridPos(global_position)
	if buildProgress >=1:
		tilemapManager.placeFinishedStructure(self, pos)
		tilemapManager.path_finder.astar_grid.set_point_solid(pos,true)
		return true
	else:
		return false
		
func on_rightclick():
	print("rightclick")
