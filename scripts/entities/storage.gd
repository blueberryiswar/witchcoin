extends Node

@export var tileMapIndex : Vector2i
@export var placingMode : UI.PlacingMode
@export var terrain : UI.Terrain = UI.Terrain.STORAGE
@export var tile_id : UI.Tile_id = UI.Tile_id.STORAGE
@export var buildDifficulty : float = 1
@export var category : Buildable.BuildCategory = Buildable.BuildCategory.AREA

var buildProgress : float = 0

var global_position : Vector2
var pos : Vector2i

var tilemapManager = null

#func tryBuild(amount : float) -> bool:
	#buildProgress += amount * 1/buildDifficulty
	#
	#if buildProgress >=1:
		#tilemapManager.OnConstructionComplete(self)
		#return true
	#else:
		#return false
