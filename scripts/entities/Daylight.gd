extends CanvasModulate

const NIGHT_COLOR = Color("#091d3a")
const DAY_COLOR = Color("#ffffff")
var target_color = NIGHT_COLOR
var current_color = NIGHT_COLOR
var switch_color = false
var daylight = false
var time = 0
var change = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.color = NIGHT_COLOR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(switch_color):
		time += delta * 0.1
		change = sin(time)
		self.color = current_color.lerp(target_color, change)
		if(change == 1.0): 
			switch_color = false
			change = 0
			time = 0


func _on_day_night_cycle_sunrise():
	target_color = DAY_COLOR
	current_color = NIGHT_COLOR
	switch_color = true

func _on_day_night_cycle_sunset():
	target_color = NIGHT_COLOR
	current_color = DAY_COLOR
	switch_color = true
