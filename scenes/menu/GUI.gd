extends CanvasLayer

#173 - RPM
# -20.196
var RpmMeterOriginalRotation = -20.196
var SpeedMeterOriginalRotation = -17

func _ready():
	pass 
	
func _process(_delta):
	$BottomUI/Speed/SpeedValue.text = str(snapped($"../CarBody".velocity.length() * 0.06, 0.01))
	$BottomUI/Speedometer/RpmMeter.rotation_degrees = RpmMeterOriginalRotation + abs(($"../CarBody".rpm/7000) * 173)
	$BottomUI/Speedometer/SpeedMeter.rotation_degrees = SpeedMeterOriginalRotation + \
												snapped($"../CarBody".velocity.length() * 0.06, 0.01)
	$BottomUI/Gear/Gear.text = $"../CarBody".gear
	
	if $"../CarBody".gear == "R":
		$BottomUI/Gear/Gear.set("theme_override_colors/font_color",Color("#FFCD4E"))
		#$BottomUI/Gear/Gear.add_color_override("font_color", Color(1, 1, 1, 1))
		#$BottomUI/Gear/Gear.modulate = Color(1, 1, 1, 1)
		#$BottomUI/Gear/Gear.set("theme_override_colors/font_color",Color(255, 205, 78, 1))
	else:
		$BottomUI/Gear/Gear.set("theme_override_colors/font_color",Color(255, 255, 255, 1))
		#$BottomUI/Gear/Gear.modulate = Color(255, 255, 255, 1)
		#$BottomUI/Gear/Gear.set("theme_override_colors/font_color",Color(255, 255, 255, 1))
