extends TextureButton

var gamemode = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pressed():
	if gamemode == "TimeAttack":
		var car = get_tree().get_root().find_child("Car", true, false)
		car.get_node("CarBody").reset_state()
		car.get_node("CarBody").enabled_input = false
		car.find_child("Stopwatch", true, false).reset()
		var map = get_tree().get_root().find_child("Akina", true, false)
		map.finished = false
		map.start()
		
	else:
		get_tree().get_root().find_child("CarBody", true, false).reset_state()
	get_tree().paused = false
	$"../..".queue_free()
