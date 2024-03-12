extends Control

var counting = false
var elapsed_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
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
