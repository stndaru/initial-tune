extends Node2D

var switch = true

func _ready():
	pass # Replace with function body.

func _process(_delta):
	position = get_parent().transform.x + \
			Vector2(get_parent().get_node("CollisionShape2D").get_shape().get_height(),0) + \
			Vector2(get_parent().get_node("CollisionShape2D").get_shape().get_height(),0) * 0.7
	
	get_node("HeadLampLeft").position.y = get_parent().get_node("CollisionShape2D").get_shape().get_radius() * 0.6
	get_node("HeadLampRight").position.y = get_parent().get_node("CollisionShape2D").get_shape().get_radius() * -0.6
	

