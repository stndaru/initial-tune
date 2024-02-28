extends Node

#var debugs = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMap.action_set_deadzone("ui_up", 0.1) 
	InputMap.action_set_deadzone("ui_down", 0.1) 
	InputMap.action_set_deadzone("ui_left", 0.1) 
	InputMap.action_set_deadzone("ui_right", 0.1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#debugs = debugs.bezier_interpolate(Vector2(0, 0), \
				#Vector2(0.4, 0.8), \
				#Vector2(1, 1), slider.value/100)\
	#debugs = _cubic_bezier(Vector2(0,0), Vector2(0.64,0.24), Vector2(0.62,0.97), \
							#Vector2(1,1), 5)
	#print(debugs)
	
	#rpm = clamp(
			#lerpf(rpm, rpm+gas, rpm_delay)
			#, 0, max_rpm)
	pass
	
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s
