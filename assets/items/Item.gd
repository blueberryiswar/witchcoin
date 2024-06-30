extends Sprite2D

class_name Item
enum ItemType {ITEM = 0, FOOD = 1, RESSOURCE = 2, WEAPON = 3, CLOTHES = 4}

@export var count : int
@export var weight : float
@export var item_type : ItemType

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("item")


