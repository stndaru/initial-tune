extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"../..".queue_free()
	var main_menu_button = preload("res://scenes/menu/MainMenuButton.tscn").instantiate()
	get_tree().get_root().find_child("Screen", true, false).add_child(main_menu_button)
