extends Camera2D

@export var max_zoom : Vector2
@export var min_zoom : Vector2
@export var pan_speed : float
var dragging = false
var drag_start_mouse_pos : Vector2
var drag_start_camera_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("zoom_in"):
		changeZoom(true)
	
	if event.is_action_pressed("zoom_out"):
		changeZoom(false)
	
	if event.is_action("up"):
		simple_pan(Vector2.UP)
		
	if event.is_action("down"):
		simple_pan(Vector2.DOWN)
		
	if event.is_action("left"):
		simple_pan(Vector2.LEFT)
		
	if event.is_action("right"):
		simple_pan(Vector2.RIGHT)
		
	if event.is_action_pressed("pan"):
		click_and_drag(true)
		
	if event.is_action_released("pan"):
		click_and_drag(false)

func _process(delta):
	if dragging:
		var camera_movement = (drag_start_mouse_pos - get_viewport().get_mouse_position()) / 2
		move_camera(camera_movement)
	
func changeZoom(zoomIn : bool):
	if(zoomIn):
		zoom = clamp(zoom.slerp(zoom * 1.1, 0.5), min_zoom, max_zoom)
	else:
		zoom = clamp(zoom.slerp(zoom * 0.9, 0.5), min_zoom, max_zoom)
	
func simple_pan(direction : Vector2):
	move_camera(direction * pan_speed)
	
func click_and_drag(active):
	dragging = active
	drag_start_camera_pos = position
	drag_start_mouse_pos = get_viewport().get_mouse_position()
	
func move_camera(moveAmount : Vector2):
	position += moveAmount * 1/zoom.x