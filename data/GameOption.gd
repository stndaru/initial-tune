extends Node

var dragostea = 0
var boccher = 0

var main_menu = 0
var main_menu_button = 0
var race_select = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = preload("res://scenes/menu/MainMenu.tscn")
	main_menu_button = preload("res://scenes/menu/MainMenuButton.tscn")
	race_select = preload("res://scenes/menu/RaceSelect.tscn")
	
	dragostea = preload("res://assets/music/dragostea.mp3")
	boccher = preload("res://assets/music/boccherguitarloneliness.mp3")

func reset_shader():
	get_tree().get_root().find_child("Shader", true, false).get_child(0).queue_free()
	get_tree().get_root().find_child("Shader", true, false).add_child(preload("res://scenes/ShaderVCR.tscn").instantiate())

func set_music(music_data):
	get_tree().get_root().get_node("Main").get_node("Music").stop()
	if music_data == "dragostea":
		get_tree().get_root().get_node("Main").get_node("Music").stream = dragostea
	elif music_data == "boccher":
		get_tree().get_root().get_node("Main").get_node("Music").stream = boccher
	get_tree().get_root().get_node("Main").get_node("Music").play()
	
