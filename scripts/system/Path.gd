extends Node2D

@onready var pawn = $".."


func _process(delta):
	queue_redraw()
	
func _draw():
	var path = pawn.current_point_path
	if len(path) < 2:
		return
	draw_polyline(pawn.current_point_path,Color(1.0, 1.0, 1.0, 0.5), 1.5 )
