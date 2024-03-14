extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(FOCUS_NONE)

func _on_pressed():
	var tune_settings = "Power: %s, Final Drive: %s, Gear 1: %s, Gear2: %s, Gear 3: %s, Gear 4: %s, Gear 5: %s, Brake Power: %s, Steering Weight: %s, Car Weight: %s"
	var tune_settings_formatted = tune_settings % [$"../TuningButton/PowerSlider/Value".text, \
								$"../TuningButton/FinalDriveSlider/Value".text, \
								$"../TuningButton/GearOneSlider/Value".text, \
								$"../TuningButton/GearTwoSlider/Value".text, \
								$"../TuningButton/GearThreeSlider/Value".text, \
								$"../TuningButton/GearFourSlider/Value".text, \
								$"../TuningButton/GearFiveSlider/Value".text, \
								$"../TuningButton/BrakeSlider/Value".text, \
								$"../TuningButton/SteeringWeightSlider/Value".text, \
								$"../TuningButton/WeightSlide/Value".text]
	DisplayServer.clipboard_set(tune_settings_formatted)
