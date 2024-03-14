extends Node2D

var switch = true

func _ready():
	pass # Replace with function body.

func _process(_delta):
	get_node("HeadLampLeftSmall").position = get_parent().get_node("CarCollision").get_polygon()[18] + Vector2((215*0.8),0)
	get_node("HeadLampRightSmall").position = get_parent().get_node("CarCollision").get_polygon()[20] + Vector2((215*0.8),0)
	
	get_node("HeadLampLeftLarge").position = get_parent().get_node("CarCollision").get_polygon()[18] + Vector2((215),0)
	get_node("HeadLampRightLarge").position = get_parent().get_node("CarCollision").get_polygon()[20] + Vector2((215),0)
	
func switch_light():
	if switch:
		get_node("HeadLampLeftSmall").energy = 0.8
		get_node("HeadLampRightSmall").energy = 0.8
		get_node("HeadLampLeftLarge").energy = 1.2
		get_node("HeadLampRightLarge").energy = 1.2
	else:
		get_node("HeadLampLeftSmall").energy = 0
		get_node("HeadLampRightSmall").energy = 0
		get_node("HeadLampLeftLarge").energy = 0
		get_node("HeadLampRightLarge").energy = 0

func switch_light_on():
	switch = true
	switch_light()
	
func switch_light_off():
	switch = false
	switch_light()
