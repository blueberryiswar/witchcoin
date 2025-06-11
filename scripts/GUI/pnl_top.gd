@tool
extends Panel

@onready var text_label: Label = $Label
var active_pawns : Array[String]
var names : String = "Active pawn: "

# Just a workaround. Would be better if text label only updates after changing active pawn

func _process(delta):
	var pawns = get_tree().get_nodes_in_group("Pawn")
	for pawn in pawns:
		if pawn.active and !active_pawns.has(pawn.pawn_name):
			active_pawns.append(pawn.pawn_name)
		elif !pawn.active and active_pawns.has(pawn.pawn_name):
			active_pawns.erase(pawn.pawn_name)
	names = "Active pawn: "
	for name in active_pawns:
			names += name
	text_label.text = ""
	text_label.text = str(names)
