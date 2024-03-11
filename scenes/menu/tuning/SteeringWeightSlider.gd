extends Control

var car_data = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	car_data = get_tree().get_root().find_child("CarBody", true, false)
	$Slider.set_focus_mode(0)
	$Slider.min_value = 0.47
	$Slider.max_value = 0.53
	$Slider.step = 0.01
	$Slider.value = car_data.steering_weight_multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Value.text = str($Slider.value)
	car_data.steering_weight_multiplier = $Slider.value
