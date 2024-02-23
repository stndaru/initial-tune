extends Node2D

var switch = true

func _ready():
	pass

func _process(_delta):
	show()
	
	get_node("BrakeLampLeft").set_energy(0.3)
	get_node("BrakeLampRight").set_energy(0.3)
	
	position = get_parent().transform.x - \
			Vector2(get_parent().get_node("CollisionShape2D").get_shape().get_height(),0) + \
			Vector2(get_parent().get_node("CollisionShape2D").get_shape().get_height(),0) * 0.55
	
	get_node("BrakeLampLeft").position.y = get_parent().get_node("CollisionShape2D").get_shape().get_radius() * 0.6
	get_node("BrakeLampRight").position.y = get_parent().get_node("CollisionShape2D").get_shape().get_radius() * -0.6
	
	if Input.is_action_pressed("ui_up") and !switch:
		hide()
	
	if Input.is_action_pressed("ui_down"):
		get_node("BrakeLampLeft").set_energy(1)
		get_node("BrakeLampRight").set_energy(1)
		

