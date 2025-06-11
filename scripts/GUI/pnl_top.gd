@tool
extends Panel

@onready var text_label: Label = $Label
var active_pawns : Array[String]
var names : String = "Active pawns:"

func _ready():
	update_label()

func update_label():
	visible = true
	var pawns = get_tree().get_nodes_in_group("Pawn")
	for pawn in pawns:
		if pawn.active and !active_pawns.has(pawn.pawn_name):
			active_pawns.append(pawn.pawn_name)
		elif !pawn.active and active_pawns.has(pawn.pawn_name):
			active_pawns.erase(pawn.pawn_name)
	names = "Active pawns:"
	for name in active_pawns:
			names += " " + name + ", "
	text_label.text = ""
	text_label.text = str(names)

func _on_pawn_active_pawn_changed():
	update_label()

func _on_pawn_2_active_pawn_changed():
	update_label()
