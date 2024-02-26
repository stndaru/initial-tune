extends CharacterBody2D

# General Default Value
var turn = 0 # Rate at which steer angle increases
var turn_rate = 0.5 # Rate of change for turn
var gas = 0 # Rate at which rpm increases
var gas_rate = 0.2 # Rate of change for gas
var debugs = Vector2.ZERO

# Gearing
var gear = 0
var gear_index = 1
var gear_shift = ["R" ,"N" ,1 ,2 ,3 ,4 ,5]
var gear_ratio = [-0.3, 0, 0.4, 0.5, 0.7, 0.9, 1]
var gear_limit = [[0,-0], [0,0], \
					[0, 0], [0,0], [0,0], [0,0], [0,0]]

# Steering Property
var steer_angle = 0
var steer_decay = 1

# Car Manueverability Data
var wheel_base = 70  # Distance from front to rear wheel, default 70
var steering_angle = 45  # Amount that front wheel turns, in degrees
var steering_weight = 0
# Multiplier to control power steering, lower means higher manueverability
# Recommended range: 0.47-0.53
var steering_weight_multiplier = 0.5
var weight = 1.2 # Car Weight
var rear_wheel = Vector2.ZERO
var front_wheel = Vector2.ZERO
var new_heading = Vector2.ZERO
var new_heading_dot = Vector2.ZERO

# Car Engine Data
var engine_power = 700  # Forward acceleration force.
var acceleration = Vector2.ZERO

# Engine Property
var rpm = 0
var max_rpm = 7
var rpm_decay = 50
var rpm_delay = 0.8 # Delay of rpm following gas input
var torque = 0

# Car Friction and Drag
var counter_force = Vector2.ZERO
var friction = -0.9
var friction_force = Vector2.ZERO
var drag = -0.0015
var drag_force = Vector2.ZERO

# Reverse and Brake
var brake_power = -2
var max_speed_reverse = 2500

# Traction
var traction = 0
var slip_speed = 1200  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	wheel_base = get_node("CollisionShape2D").get_shape().get_height() - (get_node("CollisionShape2D").get_shape().get_height() * 0.15)
	gear = gear_shift[gear_index]
	rear_wheel = position - transform.x * wheel_base / 2.0
	front_wheel = position + transform.x * wheel_base / 2.0
	new_heading = (front_wheel - rear_wheel).normalized()
	traction = traction_slow
	new_heading_dot = new_heading.dot(velocity.normalized())
	

func _input(event):
	if event.is_action_pressed("ui_shift_up") || event.is_action_pressed("ui_shift_down"):
		if event.is_action_pressed("ui_shift_up"):
			gear_index = clamp(gear_index + 1, 0, gear_shift.size()-1)
		elif event.is_action_pressed("ui_shift_down"):
			gear_index = clamp(gear_index - 1, 0, gear_shift.size()-1)
		process_gear()

func _physics_process(delta):
	print("TORQUE:", snapped(torque, 0.01), \
			" RPM:", snapped(rpm, 0.01), " SPEED:", snapped(velocity.length(),0.01), \
			" GEAR:", gear, \
			" || ", \
			" STRWGT:", steering_weight-3, \
			" LOGVEL:", log(velocity.length()), \
			" TURN:", turn)
			#" INTPLT:", debugs, \
			#" GAS:", gas, \
			#" GEARODX:", gear_index, \
			#" NEWHEAD:", snapped(new_heading, 0.01), \
			#" NEWHEADD:", snapped(new_heading_dot, 0.01) )
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
		steering_weight = log(velocity.length()) * steering_weight_multiplier
		if Input.is_action_pressed("ui_right"):
			if turn < 0:
				turn = 0
			turn += turn_rate/steering_weight
		if Input.is_action_pressed("ui_left"):
			if turn > 0:
				turn = 0
			turn -= turn_rate/steering_weight
		# Implement steering weight at velocity to reduce turn rate
		steer_angle = clamp(steer_angle + turn, \
				-steering_angle+(steering_angle*(steering_weight-3)*1.2), \
				steering_angle-(steering_angle*(steering_weight-3)*1.2))
	else:
		steer_angle = move_toward(steer_angle, 0, steer_decay+(steer_decay*steering_weight_multiplier))
		turn = move_toward(turn, 0, steer_decay+(steer_decay*steering_weight_multiplier))
		
	if Input.is_action_pressed("ui_up"):
		gas = clamp(gas + gas_rate, 0, max_rpm)
		rpm = _cubic_bezier(Vector2(0,0), Vector2(0.64,0.24), Vector2(0.62,0.97), \
						Vector2(1,1), gas/7).y * 7000
	else:
		gas = move_toward(gas, 0, gas_rate)
		rpm = move_toward(rpm, 0, rpm_decay)
	
	# transform.x is direction of force horizontally (going forward)
	torque = gas * (rpm/7000) * (engine_power*gear_ratio[gear_index])
	acceleration = transform.x * torque
	
	if Input.is_action_pressed("ui_down"):
		counter_force += velocity * brake_power/clamp(log(velocity.length())-3,0.1,0.8)

func process_gear():
	gear = gear_shift[gear_index]
	# TODO Set RPM downshift based on final drive ratio
	#rpm = 

func calculate_steering(delta):
	# Set the Wheel Positions
	rear_wheel = position - transform.x * wheel_base / 2.0
	front_wheel = position + transform.x * wheel_base / 2.0
	
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(deg_to_rad(steer_angle)) * delta
	
	new_heading = (front_wheel - rear_wheel).normalized()
	traction = traction_slow
	
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	new_heading_dot = new_heading.dot(velocity.normalized())
	if new_heading_dot > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if new_heading_dot < 0:
		velocity = velocity.lerp(-new_heading * velocity.length(), traction)
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


func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s
