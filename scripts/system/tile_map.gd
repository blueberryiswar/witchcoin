@tool
extends TileMapLayer

@onready var ground: TileMapLayer = %Ground
@onready var shadow: TileMapLayer = %Shadow
@onready var structure: TileMapLayer = %structure
@onready var clickables: TileMapLayer = %clickables
@onready var build: TileMapLayer = %build
@onready var construction: TileMapLayer = %construction
@onready var data: TileMapLayer = %data
@onready var path_finder: Pathfinder = $"../PathFinding"
var constructions = {} # {Vector2i:Construction}

signal readyToBuild(construction)

func placeConstructionOrder(placingPrototype, tileMapGridPos):
	var newConstruction = placingPrototype.duplicate()
	
	constructions[tileMapGridPos] = newConstruction
	newConstruction.global_position = gridToGlobalPos(tileMapGridPos)
	newConstruction.tilemapManager = self
	if newConstruction.category == 1:
		if structure.get_cell_tile_data(tileMapGridPos) == null:
			structure.set_cell(tileMapGridPos,newConstruction.tile_id,newConstruction.tileMapIndex)
			onConstructionComplete(newConstruction,structure)
	else:
		if build.get_cell_tile_data(tileMapGridPos) == null:
			build.set_cell(tileMapGridPos,newConstruction.tile_id,newConstruction.tileMapIndex)
			onConstructionComplete(newConstruction,build)
			clickables.set_cell(tileMapGridPos,4,Vector2i(0,0),1)
			var pawnAIs = get_tree().get_nodes_in_group("pawn_AI")
			for pawnAI in pawnAIs:
				if pawnAI.current_action == pawnAI.PawnAction.Idle:
					pawnAI.task_manager.add_task(Task.TaskType.Construct, newConstruction)
			
func placeFinishedStructure(construction, tileMapGridPos):
	var newStructure = construction.duplicate()
	constructions[tileMapGridPos] = newStructure
	newStructure.global_position = gridToGlobalPos(tileMapGridPos)
	newStructure.tilemapManager = self
	
	structure.set_cell(tileMapGridPos,newStructure.tile_id,newStructure.tileMapIndex)
	build.erase_cell(tileMapGridPos)
	onConstructionComplete(newStructure,structure)
		
func onConstructionComplete(construction,layer):
	var construction_pos = globalToGridPos(construction.global_position)
	var cells : Array[Vector2i]
	var surroundingCells = layer.get_surrounding_cells(construction_pos)
	if !surroundingCells.is_empty():
		cells.append(construction_pos)
		for cell in surroundingCells:
			var tileID = layer.get_cell_source_id(cell)
			if tileID != null:
				if tileID == construction.tile_id:
					if !cells.has(cell):
						cells.append(cell)
	if !cells.is_empty():
		layer.set_cells_terrain_connect(cells,construction.terrain,0)
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
	
func isCellEmpty(pos : Vector2i,layer) -> bool:
	if layer.get_cell_tile_data(pos) == null:
		return true
	else:
		return false
