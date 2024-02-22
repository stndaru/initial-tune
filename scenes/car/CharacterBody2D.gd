extends CharacterBody2D

# General Default Value
var turn = 0 # Rate at which steer angle increases
var turn_rate = 0.5 # Rate of change for turn
var gas = 0 # Rate at which rpm increases
var gas_rate = 0.5 # Rate of change for gas

# Steering Property
var steer_angle = 0
var steer_decay = 0.7

# Car Manueverability Data
var wheel_base = 70  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var weight = 1.2 # Car Weight

# Car Engine Data
var engine_power = 300  # Forward acceleration force.
var acceleration = Vector2.ZERO

# Engine Property
var rpm = 0
var max_rpm = 7
var rpm_decay = 0.5
var rpm_delay = 0.8 # Delay of rpm following gas input
var torque = 0

# Car Friction and Drag
var friction = -0.9
var drag = -0.0015

# Reverse and Brake
var braking = -450
var max_speed_reverse = 250

# Traction
var slip_speed = 700  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	print(rpm)
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	# Here acceleration is already calculated in get_input() and apply_friction()
	# As there is no Force in CharacterBody2D, use velocity instead
	# Velocity is the direction based on force on x and force on y, 
	# somehow need way to make this a quadratic curve
	velocity += acceleration / weight * delta
	move_and_slide()

# TODO Change input from using turn_rate to 0 and 1 and use axis for joystick support
# Reference https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
func get_input():
	# Car Steering Wheel Data, Higher Turn -> Steering Wheel Turned More
	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_right"):
			if turn < 0:
				turn = 0
			turn += turn_rate
		if Input.is_action_pressed("ui_left"):
			if turn > 0:
				turn = 0
			turn -= turn_rate
		steer_angle = clamp(steer_angle + turn, -steering_angle, steering_angle)
	else:
		steer_angle = move_toward(steer_angle, 0, steer_decay)
		turn = move_toward(turn, 0, steer_decay)
		
	if Input.is_action_pressed("ui_up"):
		gas += gas_rate
		rpm = clamp(lerpf(rpm, rpm+gas, rpm_delay), 0, max_rpm)
	else:
		gas = move_toward(gas, 0, gas_rate)
		rpm = move_toward(rpm, 0, rpm_decay)
	
	# transform.x is direction of force
	torque = rpm * engine_power
	acceleration = transform.x * torque
	
	if Input.is_action_pressed("ui_down"):
		acceleration = transform.x * braking


func calculate_steering(delta):
	# Set the Wheel Positions
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(deg_to_rad(steer_angle)) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	# Frr  = v * Crr
	var friction_force = velocity * friction
	# Fdrag = v * |v| * Cdrag
	var drag_force = velocity * velocity.length() * drag
	
	if velocity.length() < 100:
		friction_force *= 3
	
	# Flong += Frr + Fdrag
	acceleration += drag_force + friction_force
