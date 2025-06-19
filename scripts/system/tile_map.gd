@tool
extends TileMapLayer

@onready var ground: TileMapLayer = %Ground
@onready var shadow: TileMapLayer = %Shadow
@onready var build: TileMapLayer = %build
@onready var construction: TileMapLayer = %construction
@onready var data: TileMapLayer = %data
@onready var path_finder: Pathfinder = $"../PathFinding"

var constructions = {} # {Vector2i:Construction}

func placeConstructionOrder(placingPrototype, tileMapGridPos):
	var newConstruction = placingPrototype.duplicate()
	
	newConstruction.add_to_group(newConstruction.get_name())
	
	constructions[tileMapGridPos] = newConstruction
	newConstruction.position = gridToGlobalPos(tileMapGridPos)
	newConstruction.tilemapManager = self
	if build.get_cell_tile_data(tileMapGridPos) == null:
		build.set_cell(tileMapGridPos,newConstruction.tile_id,newConstruction.tileMapIndex)
		onConstructionComplete(newConstruction)
	makeCellsSolid([tileMapGridPos])

func onConstructionComplete(construction):
	var construction_pos = globalToGridPos(construction.position)
	var cells : Array[Vector2i]
	var surroundingCells = build.get_surrounding_cells(construction_pos)
	if !surroundingCells.is_empty():
		for cell in surroundingCells:
			var tileID = build.get_cell_source_id(cell)
			if tileID != null:
				if tileID == construction.tile_id:
					if !cells.has(cell):
						cells.append(cell)
	if !cells.is_empty():
		build.set_cells_terrain_connect(cells,construction.terrain,0)
		makeCellsSolid(cells)
	else:
		return
		
func makeCellsSolid(cells : Array[Vector2i]):
	for cell in cells:
		var tile_data = build.get_cell_tile_data(cell)
		if tile_data != null:
			var tile_solid = tile_data.get_custom_data("solid")
			if tile_solid != null:
				if tile_solid:
					path_finder.astar_grid.set_point_solid(cell,true)

func makeCellsNotSolid(cells : Array[Vector2i]):
	for cell in cells:
		var tile_data = build.get_cell_tile_data(cell)
		if tile_data != null:
			var tile_solid = tile_data.get_custom_data("solid")
			if tile_solid != null:
				if !tile_solid:
					path_finder.astar_grid.set_point_solid(cell,false)

func globalToGridPos(globalPos : Vector2) -> Vector2i:
	var x = globalPos.x / tile_set.tile_size.x
	var y = globalPos.y / tile_set.tile_size.y
	return Vector2i(x,y)

func gridToGlobalPos(gridPos : Vector2i) -> Vector2:
	var x = gridPos.x * tile_set.tile_size.x
	var y = gridPos.y * tile_set.tile_size.y
	return Vector2(x,y)
