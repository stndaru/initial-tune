extends Node2D

var switch = true

func _ready():
	hide()

func _process(_delta):
	
	get_node("ReverseLampLeft").position = get_parent().get_node("CarCollision").get_polygon()[6]
	get_node("ReverseLampRight").position = get_parent().get_node("CarCollision").get_polygon()[2]
	
	if get_parent().gear_index == 0:
		show()
	else:
		hide()

