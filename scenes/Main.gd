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
	
	var splashscreen_namelogo = get_node("/root/GameOption").splashscreen_namelogo
	var splashscreen_namelogo_instance = splashscreen_namelogo.instantiate()
	
	var splashscreen_unilogo = get_node("/root/GameOption").splashscreen_unilogo
	var splashscreen_unilogo_instance = splashscreen_unilogo.instantiate()
	
	var splashscreen_attribution = get_node("/root/GameOption").splashscreen_attribution
	var splashscreen_attribution_instance = splashscreen_attribution.instantiate()
	
	get_tree().get_root().get_node("Main").add_child(splashscreen_namelogo_instance)
	await get_tree().create_timer(2).timeout
	get_tree().get_root().find_child("LogoName", true, false).queue_free()
	get_tree().get_root().get_node("Main").add_child(splashscreen_unilogo_instance)
	await get_tree().create_timer(2).timeout
	get_tree().get_root().find_child("UniLogo", true, false).queue_free()
	get_tree().get_root().get_node("Main").add_child(splashscreen_attribution_instance)
	await get_tree().create_timer(2).timeout
	get_tree().get_root().find_child("Attribution", true, false).queue_free()
	
	main_menu_instance.add_child(main_menu_button_instance)
	get_tree().get_root().get_node("Main").add_child(main_menu_instance)
	get_node("/root/GameOption").set_music("Dragostea Din Tei")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#time += delta
	#print(get_tree().get_root().find_child("Shader", true, false).get_children(), time)
