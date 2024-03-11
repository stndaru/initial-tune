extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	var main_menu_button = get_node("/root/GameOption").main_menu_button.instantiate()
	get_tree().get_root().find_child("Screen", true, false).add_child(main_menu_button)
	get_tree().get_root().find_child("RaceSelect", true, false).queue_free()
