@tool
extends Panel

@export var reset : bool = false
@export var column_count : int = 2
@onready var UI = $".."

var buttons = []
var current_buildable : String = ""

func _ready():
	load_buttons()
	for button in buttons:
		button.connect("pressed", on_button_pressed.bind(button))

func on_button_pressed(button: Button):
	open_submenu(button.text)
	
func on_button_pressed_buildable(buildable : Buildable):
	UI.begin_placing(buildable)
	
func close_menus():
	self.set_visible(false)
	current_buildable = ""
	
	for child in get_children():
		if child is Panel:
			child.set_visible(false)
			for i in range(child.get_child_count()):
				child.get_children()[0].queue_free()
	
func open_submenu(menu : String):
	if menu == current_buildable:
		find_child("pnl_buildable").set_visible(false)
		current_buildable = ""
	else:
		current_buildable = menu
		find_child("pnl_buildable").set_visible(true)
		match menu:
			"Walls":
				load_build_menu(menu)
			"Storage":
				load_build_menu(menu)
				
func load_build_menu(menu : String):
	var pnl_buildable = find_child("pnl_buildable")
	
	var buildables = UI.item_manager.blueprints
	#["Cancel", "Wall", "Door"]
	
	for i in range(pnl_buildable.get_child_count()):
		pnl_buildable.get_child(i).queue_free()
		
	for i in range(len(buildables)):
		var button = Button.new()
		pnl_buildable.add_child(button)
		button.text = buildables[i].name
		var button_size = 64.0
		button.size = Vector2(button_size, button_size)
		button.position = Vector2(button_size * i + 4 * i, pnl_buildable.size.y - button_size)
		button.connect("pressed", on_button_pressed_buildable.bind(buildables[i]))

func _process(delta):
	if reset:
		reset = false
		load_buttons()
		arrange_buttons()
		arrange_self()
		
func arrange_buttons():
	var rows = (len(buttons) + 1) / column_count
	
	for i in range(len(buttons)):
		var column = i%column_count
		var row = i / column_count
		
		buttons[i].anchor_top = row * 1/float(rows)
		buttons[i].anchor_bottom = 1 / float(rows) + row * 1 / float(rows)
		buttons[i].anchor_left = column * 1 / float(column_count)
		buttons[i].anchor_right = 1 / float(column_count) + column * 1/float(column_count)
		
		buttons[i].offset_bottom = 0
		buttons[i].offset_top = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
	
		 
func arrange_self():
	anchor_left = 0
	anchor_right = 0.3
	anchor_bottom = 1 - UI.button_height
	
	var rows = (len(buttons) + 1) / column_count
	anchor_top = anchor_bottom - UI.button_height * rows
	
	offset_bottom = 0
	offset_right = 0
	offset_left = 0
	offset_top = 0	

func load_buttons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
			
