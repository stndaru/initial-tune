extends Node

#var debugs = Vector2.ZERO
var is_paused = false
var pause_menu = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMap.action_set_deadzone("ui_up", 0.1) 
	InputMap.action_set_deadzone("ui_down", 0.1) 
	InputMap.action_set_deadzone("ui_left", 0.1) 
	InputMap.action_set_deadzone("ui_right", 0.1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu = preload("res://scenes/menu/PauseMenu.tscn")
		if not is_paused:
			get_tree().paused = true
			get_node("Car").get_node("GUI").add_child(pause_menu.instantiate())
		else:
			get_tree().paused = false
	
