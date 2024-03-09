extends Node2D

var switch = true

func _ready():
	pass # Replace with function body.

func _process(_delta):
	get_node("HeadLampLeftSmall").position = get_parent().get_node("CarCollision").get_polygon()[18] + Vector2((215*0.8),0)
	get_node("HeadLampRightSmall").position = get_parent().get_node("CarCollision").get_polygon()[20] + Vector2((215*0.8),0)
	
	get_node("HeadLampLeftLarge").position = get_parent().get_node("CarCollision").get_polygon()[18] + Vector2((215),0)
	get_node("HeadLampRightLarge").position = get_parent().get_node("CarCollision").get_polygon()[20] + Vector2((215),0)
	

