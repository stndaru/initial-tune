extends Node

#var debugs = Vector2.ZERO
var is_paused = false

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
		if not is_paused:
			get_tree().paused = true
		else:
			get_tree().paused = false
	
