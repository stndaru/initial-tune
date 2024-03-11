extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _on_pressed():
	var map = preload("res://scenes/race/map/akina/Akina.tscn")
	var car = preload("res://scenes/car/Car.tscn")
	var tuning_menu = preload("res://scenes/menu/tuning/TuningMenu.tscn")
	
	var map_instance = map.instantiate()
	var car_instance = car.instantiate()
	var tuning_menu_instance = tuning_menu.instantiate()
	
	var car_data = car_instance.get_node("CarBody")
	var tune_data = get_node("/root/TuneData")
	update_tune(car_data, tune_data)
	
	car_instance.get_node("GUI").add_child(tuning_menu_instance)
	map_instance.add_child(car_instance)
	
	#get_tree().get_root().get_node("Main").get_node("MainMenu").get_node("BGM").stop()
	get_tree().get_root().get_node("Main").get_node("MainMenu").queue_free()
	get_tree().get_root().get_node("Main").add_child(map_instance)
	get_node("/root/GameOption").reset_shader()
	
func update_tune(car_data, tune_data):
	car_data.engine_power = tune_data.engine_power
	car_data.gear_ratio = tune_data.gear_ratio
	car_data.final_drive_ratio = tune_data.final_drive_ratio
	car_data.steering_angle = tune_data.steering_angle
	car_data.steering_weight_multiplier = tune_data.steering_weight_multiplier
	car_data.weight = tune_data.weight
	car_data.friction = tune_data.friction
	car_data.brake_power = tune_data.brake_power
	
	print(car_data.engine_power, " ", tune_data.engine_power)
