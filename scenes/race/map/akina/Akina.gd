extends Node

#var debugs = Vector2.ZERO
var is_paused = false
var pause_menu = 0
var timer_screen = 0
var timer_screen_instance = 0
var finish_screen = 0
var gamemode = "None"
var finished = false
var started = false

# Cheatcode - Should only be 5 character long
var buffer = "ABCDE"
var zawarudo = false

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMap.action_set_deadzone("ui_up", 0.1) 
	InputMap.action_set_deadzone("ui_down", 0.1) 
	InputMap.action_set_deadzone("ui_left", 0.1) 
	InputMap.action_set_deadzone("ui_right", 0.1) 
	pause_menu = preload("res://scenes/menu/PauseMenu.tscn")
	timer_screen = preload("res://scenes/menu/TimerScreen.tscn")
	finish_screen = preload("res://scenes/menu/FinishScreen.tscn")
	
	
func set_gamemode():
	if gamemode == "TimeAttack":
		get_node("Car").get_node("GUI").get_node("Stopwatch").visible = true
		get_node("Car").get_node("CarBody").enabled_input = false
		
func start():
	if gamemode == "TimeAttack":
		timer_screen_instance = timer_screen.instantiate()
		get_node("Car").get_node("GUI").add_child(timer_screen_instance)
		started = false
		finished = false
		$StartTimer.start()
		
func reset_timer():
	timer_screen_instance.queue_free()
	started = false
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not is_paused and not finished:
			get_tree().paused = true
			var pause_menu_instance = pause_menu.instantiate()
			pause_menu_instance.set_gamemode(gamemode)
			get_node("Car").get_node("GUI").add_child(pause_menu_instance)
		else:
			get_tree().paused = false
			
	# Cheat Code - Task 2
	if event is InputEventKey and event.is_pressed():
		buffer = buffer.substr(1) + event.as_text_keycode()[0]
		
		# Stops Time
		if buffer.to_upper() == "ZAWRD" and gamemode == "TimeAttack":
			if not zawarudo:
				get_node("Car").get_node("GUI").get_node("Stopwatch").stop()
			else:
				get_node("Car").get_node("GUI").get_node("Stopwatch").start()
			zawarudo = !zawarudo
		
		# Halven the Time Taken
		if buffer.to_upper() == "HTEZZ" and gamemode == "TimeAttack":
			get_node("Car").get_node("GUI").get_node("Stopwatch").toggle_halftime()
		
		# Remove COllision
		if buffer.to_upper() == "FREEC":
			get_node("Car").get_node("CarBody").get_node("CarCollision").disabled = !get_node("Car").get_node("CarBody").get_node("CarCollision").disabled
		
	
func _on_finish_line_body_entered(body):
	if gamemode == "TimeAttack":
		if body.name == "CarBody":
			finished = true
			started = false
			body.enabled_input = false
			var finish_screen_instance = finish_screen.instantiate()
			finish_screen_instance.set_gamemode(gamemode)
			get_node("Car").get_node("GUI").get_node("Stopwatch").stop()
			get_node("Car").get_node("GUI").add_child(finish_screen_instance)

func _on_start_timer_timeout():
	get_node("Car").get_node("GUI").get_node("Stopwatch").start()
	get_node("Car").get_node("CarBody").enabled_input = true
	timer_screen_instance.queue_free()
	started = true
	finished = false
