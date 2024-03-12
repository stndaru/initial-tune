extends Control

var show_time = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Label.text = "Ready?"
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if show_time:
		$Control/Label.text = str(get_tree().get_root().get_node("Main").find_child("StartTimer", true, false).time_left).pad_decimals(1)

func _on_timer_timeout():
	show_time = true
