extends Control

var counting = false
var elapsed_time = 0
var half_time = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		# Cheat Code - Task 2
		if half_time:
			elapsed_time += (delta/2)
		else:
			elapsed_time += delta
		$Time.text = str(elapsed_time).pad_decimals(2)
		
func reset():
	elapsed_time = 0.0
	$Time.text = str(elapsed_time).pad_decimals(2)
	counting = false

func stop():
	counting = false
	
func start():
	counting = true

func toggle_halftime():
	half_time = !half_time
