@tool
extends Panel

@onready var text_label: Label = $Label
var active_pawns : Array[String]

func _process(delta):
	var pawns = get_tree().get_nodes_in_group("Pawn")
	for pawn in pawns:
		if pawn.active and !active_pawns.has(pawn.pawn_name):
			active_pawns.append(pawn.pawn_name)
		elif !pawn.active and active_pawns.has(pawn.pawn_name):
			active_pawns.erase(pawn.pawn_name)
	text_label.text = str(active_pawns)
