extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	var race_select = preload("res://scenes/menu/RaceSelect.tscn")
	var race_select_instance = race_select.instantiate()
	$"../..".add_child(race_select_instance)
	$"..".queue_free()
