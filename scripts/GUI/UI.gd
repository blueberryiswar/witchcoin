@tool
extends CanvasLayer

class_name UI

enum PlacingMode {SINGLE, ROW, RECTANGLE}
enum UIMode {NORMAL, PLACING, DRAGGING}
enum Terrain {WALL = 0, DIRTROAD = 1, STORAGE = 2}

var current_ui_mode : UIMode = UIMode.NORMAL
var current_placing_mode : PlacingMode = PlacingMode.SINGLE
var current_terrain : Terrain = Terrain.WALL
var placing_prototype = null
var start_placing_pos : Vector2i = Vector2i.ZERO
var clear_cell : Vector2i = Vector2i.ZERO
var placing_positions : Array[Vector2i]= []
@export var button_height = 0.05
@onready var item_manager = $"../ItemManager"
@onready var tilemap = %Ground

func _process(delta):
	if current_ui_mode != UIMode.NORMAL and Input.is_action_just_pressed("act"):
		set_ui_mode(UIMode.NORMAL)
		tilemap.clear_layer(3)
		placing_prototype = null
		start_placing_pos = Vector2i.ZERO
		placing_positions = []
	
	if(current_ui_mode == UIMode.PLACING):
		draw_prototype_at_cursor()
		if Input.is_action_just_pressed("move"):
			start_placing_pos = get_mouse_pos_tilemap()
			set_ui_mode(UIMode.DRAGGING)
	elif(current_ui_mode == UIMode.DRAGGING):
		
		match current_placing_mode:
			PlacingMode.ROW:
				draw_prototype_in_line()
				
			PlacingMode.RECTANGLE:
				draw_prototype_in_rectangle()		
		
		if Input.is_action_just_released("move"):
			place_construction_orders()
			set_ui_mode(UIMode.PLACING)
		
func draw_prototype_at_cursor():
	var pos : Vector2i = get_mouse_pos_tilemap()
	
	tilemap.set_cell(3,pos,2,Vector2i(3,3))
	if (pos != clear_cell):
		tilemap.set_cell(3,clear_cell,-1)
		clear_cell = pos
	pass
	
func draw_prototype_in_rectangle():
	var pos : Vector2i = get_mouse_pos_tilemap()
	
	var diffX = abs(pos.x - start_placing_pos.x)
	var diffY = abs(pos.y - start_placing_pos.y)
	var range_x = range(start_placing_pos.x, pos.x + 1, 1)
	var range_y = range(start_placing_pos.y, pos.y + 1, 1)
	placing_positions = []
	
	if diffX > diffY:
		range_y = range(start_placing_pos.y, pos.y + 1, 1)
	else:		
		range_y = range(start_placing_pos.y, pos.y - 1, -1)
	if pos.x > start_placing_pos.x:
		range_x = range(start_placing_pos.x, pos.x + 1, 1)
	else:
		range_x = range(start_placing_pos.x, pos.x - 1, -1)
		
	for i in range_y:
		for j in range_x:
			placing_positions.append(Vector2i(j, i))
	tilemap.set_cells_terrain_connect(3,placing_positions,current_terrain,0)
	
func draw_prototype_in_line():
	var pos : Vector2i = get_mouse_pos_tilemap()
	
	var diffX = abs(pos.x - start_placing_pos.x)
	var diffY = abs(pos.y - start_placing_pos.y)
	placing_positions = []
	
	if diffX > diffY:
		var range = range(start_placing_pos.x, pos.x + 1, 1)
		if pos.x < start_placing_pos.x:
			range = range(start_placing_pos.x, pos.x - 1, -1)
			
		for i in range:
			placing_positions.append(Vector2i(i, start_placing_pos.y))
	else:
		var range = range(start_placing_pos.y, pos.y + 1, 1)
		if pos.y < start_placing_pos.y:
			range = range(start_placing_pos.y, pos.y - 1, -1)
			
		for i in range:
			placing_positions.append(Vector2i(start_placing_pos.x, i))
			
	tilemap.set_cells_terrain_connect(3,placing_positions,0,0)

func place_construction_orders():
	pass
	
func set_ui_mode(new_mode : UIMode):
	current_ui_mode = new_mode
	
func set_placing_mode(new_placing_mode : PlacingMode):
	current_placing_mode = new_placing_mode
	
func set_terrain(new_terrain : Terrain):
	current_terrain = new_terrain

func get_mouse_pos_tilemap():
	return Vector2i(get_parent().get_global_mouse_position().x / 16, get_parent().get_global_mouse_position().y / 16)

func begin_placing(buildable : Buildable):
	print("Build: " + buildable.name)
	placing_prototype = buildable.blueprint.instantiate()
	set_placing_mode(buildable.placing_mode)
	set_terrain(buildable.terrain)
	set_ui_mode(UIMode.PLACING)
	close_menus()

func close_menus():
	for child in get_children():
		child.close_menus()
