extends Node2D

class_name Clickable_Area

var tile_map : TileMapLayer
var construction : Node

func _ready():
	tile_map = get_parent()
	tile_map = tile_map.get_parent()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("act"):
		print("rightclick")
		var build_data = tile_map.build.get_cell_tile_data(tile_map.globalToGridPos(position))
		if build_data == null:
			return
		else:
			var structure_data = tile_map.structure.get_cell_tile_data(tile_map.globalToGridPos(position))
			if structure_data != null:
				return
			else:
				# only walls atm for testing
				var construction = Wall.new()
				construction.tilemapManager = tile_map
				construction.global_position = position
				tile_map.sendConstructionTask(construction)
		
	elif event.is_action_pressed("move"):
		print("leftclick")
