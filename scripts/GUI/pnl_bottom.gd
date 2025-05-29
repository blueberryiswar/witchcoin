@tool
extends Panel

@export var reset : bool = false
@onready var UI = $".."
@export var button_container : HBoxContainer = null

var buttons = []

func _ready():
	load_buttons()
	for button in buttons:
		button.connect("pressed", on_button_pressed.bind(button))


func _process(delta):
	if reset:
		reset = false
		load_buttons()
		arrange_buttons()
		
func close_menus():
	pass
		
func on_button_pressed(button: Button):
	open_submenu(button.text)
	
func open_submenu(menu : String):
	for submenu in get_parent().get_children():
		if submenu != self:
			if menu == submenu.name:
				submenu.set_visible(!submenu.is_visible())
			else:
				submenu.set_visible(false)
	
func arrange_buttons():
	var div : float = float(1) / len(buttons)
	
	for i in range(len(buttons)):
		buttons[i].set("custom_minimum_size", Vector2(button_container.size.x * div - 2 * len(buttons), 0))
		

func load_buttons():
	buttons = []
	for child in button_container.get_children():
		if child is Button:
			buttons.append(child)
			
