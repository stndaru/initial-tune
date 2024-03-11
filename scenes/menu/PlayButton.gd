extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pressed():
	var race_select = get_node("/root/GameOption").race_select
	var race_select_instance = race_select.instantiate()
	get_tree().get_root().find_child("Screen", true, false).add_child(race_select_instance)
	get_tree().get_root().find_child("MainMenuButton", true, false).queue_free()
