extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VolumeSlider.value = get_node("/root/GameOption").get_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$VolumeValueLabel.text = str($VolumeSlider.value)

func _on_set_volume_button_pressed():
	get_node("/root/GameOption").set_volume($VolumeSlider.value)
