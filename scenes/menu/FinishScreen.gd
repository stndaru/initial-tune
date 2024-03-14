extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Time.text = get_tree().get_root().get_node("Main").find_child("Stopwatch", true, false).get_node("Time").text
	$Control/DifferenceValue.text = str(float($Control/Time.text) - 64.37).pad_decimals(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_gamemode(gamemode):
	$Control/ResetButton.gamemode = gamemode
