extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	get_tree().get_root().find_child("Akina", true, false).queue_free()
	get_tree().paused = false
	
	var main_menu = get_node("/root/GameOption").main_menu
	var main_menu_instance = main_menu.instantiate()
	var race_select = get_node("/root/GameOption").race_select
	var race_select_instance = race_select.instantiate()
	
	
	main_menu_instance.add_child(race_select_instance)
	get_tree().get_root().get_node("Main").add_child(main_menu_instance)
	get_node("/root/GameOption").set_music("dragostea")
	
