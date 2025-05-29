extends Node2D

var time = 0.0
var fuel = 30
var active = true
var is_night = true
@onready var noise:FastNoiseLite = FastNoiseLite.new()
@onready var sprite = $AnimatedSprite2D
@export var daynightcycle: Node2D


func _ready():
	if(daynightcycle):
		daynightcycle.hour_passed.connect(_on_hour_passed)
		daynightcycle.sunrise.connect(_on_sunrise)
		daynightcycle.sunset.connect(_on_sunset)


func _process(delta):
	fire_flicker(delta)
	
func _on_hour_passed():
	if(fuel > 1):
		fuel -= 1
	else:
		fuel = 0
		turn_off()

func _on_sunrise():
	is_night = false
	$Timer.start(3.0)

func _on_sunset():
	is_night = true
	$Timer.start(3.0)

func turn_off():
	active = false
	$FireLight.set_enabled(false)
	$FireLight2.set_enabled(false)
	$AnimatedSprite2D.play("off")
	
func turn_on():
	if(fuel > 0):
		active = true
		$FireLight.set_enabled(true)
		$FireLight2.set_enabled(true)
		$AnimatedSprite2D.play("on")

func fire_flicker(delta):
	if(!active): return
	self.time += delta * 10
	
	var scale = 0.9 + noise.get_noise_1d(self.time) * 0.5
	$FireLight.set_texture_scale(clamp(scale, 0.5, 1.0))
	$FireLight2.set_texture_scale(clamp(scale, 0.5, 1.0))
	#$FireLight.set_energy(clamp(scale, 0.3, 0.5))
	#$FireLight2.set_energy(clamp(scale, 0.3, 0.5))
	
func _on_timer_timeout():
	if(is_night):
		turn_on()
	else:
		turn_off()
