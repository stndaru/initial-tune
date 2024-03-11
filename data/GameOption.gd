extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_shader():
	get_tree().get_root().get_node("Main").get_node("Shader").get_node("ShaderVCR").queue_free()
	get_tree().get_root().get_node("Main").get_node("Shader").add_child(preload("res://scenes/ShaderVCR.tscn").instantiate())
