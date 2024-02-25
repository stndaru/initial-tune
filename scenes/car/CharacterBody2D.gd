extends CharacterBody2D

# General Default Value
var turn = 0 # Rate at which steer angle increases
var turn_rate = 0.5 # Rate of change for turn
var gas = 0 # Rate at which rpm increases
var gas_rate = 0.5 # Rate of change for gas
var debugs = Vector2.ZERO

# Gearing
var gear = 0
var gear_index = 1
var gear_shift = ["R" ,0 ,1 ,2 ,3 ,4 ,5]

# Steering Property
var steer_angle = 0
var steer_decay = 0.7

# Car Manueverability Data
var wheel_base = 70  # Distance from front to rear wheel, default 70
var steering_angle = 15  # Amount that front wheel turns, in degrees
var weight = 1.2 # Car Weight

# Car Engine Data
var engine_power = 500  # Forward acceleration force.
var acceleration = Vector2.ZERO

# Engine Property
var rpm = 0
var max_rpm = 7
var rpm_decay = 0.5
var rpm_delay = 0.8 # Delay of rpm following gas input
var torque = 0

# Car Friction and Drag
var counter_force = Vector2.ZERO
var friction = -0.9
var friction_force = Vector2.ZERO
var drag = -0.0015
var drag_force = Vector2.ZERO

# Reverse and Brake
var brake_power = -2.5
var max_speed_reverse = 2500

# Traction
var slip_speed = 700  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	wheel_base = get_node("CollisionShape2D").get_shape().get_height() - (get_node("CollisionShape2D").get_shape().get_height() * 0.15)

func _input(event):
	if event.is_action_pressed("ui_shift_up") || event.is_action_pressed("ui_shift_down"):
		if event.is_action_pressed("ui_shift_up"):
			gear_index = clamp(gear_index + 1, 0, gear_shift.size()-1)
		elif event.is_action_pressed("ui_shift_down"):
			gear_index = clamp(gear_index - 1, 0, gear_shift.size()-1)
		process_gear()

func _physics_process(delta):
	print("TORQUE:", torque, \
			" RPM:", snapped(rpm, 0.01), " SPEED:", snapped(velocity.length(),0.01), \
			" GEAR:", gear, \
			" || ", \
			" INTPLT:", debugs) #, \
			#" ACC:", snapped(acceleration.length(), 0.01), \
			#" CTR:", snapped(counter_force.length(), 0.01), \
			#" FR:", snapped(friction_force.length(), 0.01), \
			#" DRG:", snapped(drag_force.length(), 0.01))
			
	acceleration = Vector2.ZERO
	counter_force = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	# Here acceleration is already calculated in get_input() and apply_friction()
	# As there is no Force in CharacterBody2D, use velocity instead
	# Velocity is the direction based on force on x and force on y, 
	# somehow need way to make this a quadratic curve
	if counter_force.length() > acceleration.length() and velocity.is_zero_approx():
		velocity = Vector2.ZERO
	else:
		velocity += (acceleration + counter_force) / weight * delta
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
		gas = clamp(gas + gas_rate, 0, max_rpm)
		debugs = debugs.bezier_interpolate(Vector2(0.58, 0.28), Vector2(0.41, 0.86), velocity, 1)
		#rpm = clamp(
			#lerpf(rpm, rpm+gas, rpm_delay)
			#, 0, max_rpm)
	else:
		gas = move_toward(gas, 0, gas_rate)
		#rpm = move_toward(rpm, 0, rpm_decay)
	
	# transform.x is direction of force horizontally (going forward)
	torque = gas * engine_power
	rpm = velocity.length()
	acceleration = transform.x * torque
	
	if Input.is_action_pressed("ui_down"):
		counter_force += velocity * brake_power

func process_gear():
	gear = gear_shift[gear_index]

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
	friction_force = velocity * friction
	# Fdrag = v * |v| * Cdrag
	drag_force = velocity * velocity.length() * drag
	
	if velocity.length() < 100:
		friction_force *= 3
	elif velocity.length() > 500 and acceleration == Vector2.ZERO:
		friction_force *= 0.5
	
	# Flong += Frr + Fdrag
	counter_force += drag_force + friction_force
