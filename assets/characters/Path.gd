extends Node2D

@onready var pawn = $".."


func _process(delta):
	queue_redraw()
	
func _draw():
	if pawn.current_point_path.is_empty():
		return
	
	draw_polyline(pawn.current_point_path,Color(1.0, 1.0, 1.0, 0.5), 2.0 )
	print("drawing line")
