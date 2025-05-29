extends Sprite2D

class_name Item
enum ItemType {ITEM = 0, FOOD = 1, RESSOURCE = 2, WEAPON = 3, CLOTHES = 4}

@export var item_name : String
@export var item_description : String
@export var count : int
@export var weight : float
@export var item_type : ItemType
@onready var item_manager = $'../../ItemManager'

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("item")
