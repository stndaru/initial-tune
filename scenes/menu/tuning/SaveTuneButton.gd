extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(0)

func _on_pressed():
	update_tune_data()

func update_tune_data():
	var tune_data = get_node("/root/TuneData")
	
	tune_data.engine_power = $"../TuningButton/PowerSlider/Slider".value
	tune_data.gear_ratio[2] = $"../TuningButton/GearOneSlider/Slider".value
	tune_data.gear_ratio[3] = $"../TuningButton/GearTwoSlider/Slider".value
	tune_data.gear_ratio[4] = $"../TuningButton/GearThreeSlider/Slider".value
	tune_data.gear_ratio[5] = $"../TuningButton/GearFourSlider/Slider".value
	tune_data.gear_ratio[6] = $"../TuningButton/GearFiveSlider/Slider".value
	tune_data.final_drive_ratio = $"../TuningButton/FinalDriveSlider/Slider".value
	tune_data.steering_weight_multiplier = $"../TuningButton/SteeringWeightSlider/Slider".value
	tune_data.brake_power = $"../TuningButton/BrakeSlider/Slider".value
	tune_data.weight = $"../TuningButton/WeightSlide/Slider".value
