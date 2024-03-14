extends Node

var dragostea = 0
var boccher = 0
var dota = 0
var moonlight = 0
var rockefeller = 0

var main_menu = 0
var main_menu_button = 0
var race_select = 0
var credit = 0
var control = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = preload("res://scenes/menu/MainMenu.tscn")
	main_menu_button = preload("res://scenes/menu/MainMenuButton.tscn")
	race_select = preload("res://scenes/menu/RaceSelect.tscn")
	credit = preload("res://scenes/menu/Credits.tscn")
	control = preload("res://scenes/menu/Controls.tscn")
	
	dragostea = preload("res://assets/music/dragostea.mp3")
	boccher = preload("res://assets/music/boccherguitarloneliness.mp3")
	dota = preload("res://assets/music/dota.mp3")
	moonlight = preload("res://assets/music/moonlightshadow.mp3")
	rockefeller = preload("res://assets/music/rockefeller.mp3")

func reset_shader():
	get_tree().get_root().find_child("Shader", true, false).get_child(0).queue_free()
	get_tree().get_root().find_child("Shader", true, false).add_child(preload("res://scenes/ShaderVCR.tscn").instantiate())

func set_music(music_data):
	get_tree().get_root().get_node("Main").get_node("Music").stop()
	if music_data == "Dragostea Din Tei":
		get_tree().get_root().get_node("Main").get_node("Music").stream = dragostea
	elif music_data == "Guitar Loneliness":
		get_tree().get_root().get_node("Main").get_node("Music").stream = boccher
	elif music_data == "DOTA":
		get_tree().get_root().get_node("Main").get_node("Music").stream = dota
	elif music_data == "Moonlight Shadow":
		get_tree().get_root().get_node("Main").get_node("Music").stream = moonlight
	elif music_data == "Rockefeller Street":
		get_tree().get_root().get_node("Main").get_node("Music").stream = rockefeller
	else:
		get_tree().get_root().get_node("Main").get_node("Music").stream = boccher
	get_tree().get_root().get_node("Main").get_node("Music").play()
	
func set_volume(volume):
	get_tree().get_root().get_node("Main").get_node("Music").volume_db = volume

func get_volume():
	return get_tree().get_root().get_node("Main").get_node("Music").volume_db
