extends Node2D

var hour = 0
var day = 1
var month = 1
var year = 1300

signal hour_passed
signal new_day
signal sunrise
signal sunset
signal new_month
signal new_year



# Called when the node enters the scene tree for the first time.
func _ready():
	print("DayNight Cycle Start")
	print_current_datetime()
	
func print_current_datetime():
	print(str(day, ".", month, ".", year, " ", hour))

func _on_hour_timeout():
	hour += 1
	hour_passed.emit()
	if hour == 6:
		sunrise.emit()
	if hour == 20:
		sunset.emit()
	if hour == 24:
		hour = 0
		start_new_day()
		
	print_current_datetime()
		
	
		
func start_new_day():
	hour = 0
	day += 1
	if(day > 30):
		month + 1
		if (month > 12):
			month = 1
			year += 1
	new_day.emit()
