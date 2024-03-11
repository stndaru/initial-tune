extends Node

var dragostea = 0
var boccher = 0
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var main_menu = get_node("/root/GameOption").main_menu
	var main_menu_button = get_node("/root/GameOption").main_menu_button
	var main_menu_instance = main_menu.instantiate()
	var main_menu_button_instance = main_menu_button.instantiate()
	
	main_menu_instance.add_child(main_menu_button_instance)
	get_tree().get_root().get_node("Main").add_child(main_menu_instance)
	get_node("/root/GameOption").set_music("dragostea")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#time += delta
	#print(get_tree().get_root().find_child("Shader", true, false).get_children(), time)
