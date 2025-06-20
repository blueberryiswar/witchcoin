class_name Buildable

extends Resource

enum BuildCategory {STRUCTURE = 0, AREA = 1, FURNITURE = 2, PRODUCTION = 3}

@export var name : String
@export var category : BuildCategory
@export var tile_map_index : Vector2i
@export var placing_mode : UI.PlacingMode
@export var terrain : UI.Terrain
@export var blueprint : Resource
@export var tile_id : UI.Tile_id
