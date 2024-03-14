extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pressed():
	var credit = get_node("/root/GameOption").credit
	var credit_instance = credit.instantiate()
	get_tree().get_root().find_child("Screen", true, false).add_child(credit_instance)
	get_tree().get_root().find_child("MainMenuButton", true, false).queue_free()
