@tool
extends Panel

@onready var text_label: Label = $Label
var active_pawns : Array[String]
var names : String

func _ready():
	update_label()

func update_label():
	var pawns = get_tree().get_nodes_in_group("Pawn")
	for pawn in pawns:
		if pawn.active and !active_pawns.has(pawn.pawn_name):
			active_pawns.append(pawn.pawn_name)
		elif !pawn.active and active_pawns.has(pawn.pawn_name):
			active_pawns.erase(pawn.pawn_name)
	if active_pawns == []:
		visible = false
	else:
		visible = true
	names = "Active pawns:"
	for name in active_pawns:
		names += " " + name + ", "
	if names != "Active pawns:":
		names = names.erase(names.length()-2,2)
	else:
		names = "Active pawns: none"
	text_label.text = ""
	text_label.text = str(names)

func _on_pawn_active_pawn_changed():
	update_label()

func _on_pawn_2_active_pawn_changed():
	update_label()

func _on_pawn_3_active_pawn_changed():
	update_label()
