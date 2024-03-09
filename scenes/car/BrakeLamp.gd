extends Node2D

var switch = true

func _ready():
	pass

func _process(_delta):
	show()
	
	get_node("BrakeLampLeft").set_energy(0.3)
	get_node("BrakeLampRight").set_energy(0.3)
	
	get_node("BrakeLampLeft").position = get_parent().get_node("CarCollision").get_polygon()[6]
	get_node("BrakeLampRight").position = get_parent().get_node("CarCollision").get_polygon()[2]
	
	if Input.is_action_pressed("ui_up") and !switch:
		hide()
	
	if Input.is_action_pressed("ui_down"):
		get_node("BrakeLampLeft").set_energy(1)
		get_node("BrakeLampRight").set_energy(1)
		

