extends CharacterBody2D

# Temporary Debug Value
var type_circ = 0
var temp_speed = 0
var is_mouse_and_keyboard = true
var enabled_input = true
var light_switch = true

# General Default Value
var turn = 0 # Rate at which steer angle increases
var turn_rate = 0.5 # Rate of change for turn
var gas = 0 # Rate at which rpm increases
var gas_rate = 0.2 # Rate of change for gas
var delivered_power = 0
var rpm_rev = 0

var sound_db = 0
var sound_pitch = 1
var tween = 0
var tweenSub = 0
var tweenBass = 0

# Gearing
var gear = 0
var gear_index = 1
var gear_shift = ["R" ,"N" ,"1" ,"2" ,"3" ,"4" ,"5"]
# Gear List Customizeable
# Final Drive = [3.5,5.5]
# Gear R = [-3,-2]
# Gear 1 = [3.5, 2.5]
# Gear 2 = [2,1]
# Gear 3 = [1.2, 0.8]
# Gear 4 = [1, 0.7]
# Gear 5 = [0.9, 0.6]
var gear_ratio = [-2.8, 0, 3, 1.5, 1, 0.9, 0.81]
var gear_effectivity = 0
var final_drive_ratio = 4.5

# Steering Property
var steer_angle = 0
var steer_decay = 1

# Car Manueverability Data
var car_length = 85
var wheel_base = 70  # Distance from front to rear wheel, default 70
# Steering Angle Customizeable [30,50]
var steering_angle = 45  # Amount that front wheel turns, in degrees
var steering_weight = 0
# Multiplier to control power steering, lower means higher manueverability
# Steering Weight Multiplier Customizeable [0.47-0.53]
var steering_weight_multiplier = 0.5
# Weight Customizeable [1.1,1.3]
var weight = 1.2 # Car Weight
var rear_wheel = Vector2.ZERO
var front_wheel = Vector2.ZERO
var new_heading = Vector2.ZERO
var new_heading_dot = Vector2.ZERO

# Car Engine Data
# Engine Power Customizeable [150,200]
var engine_power = 175  # Forward acceleration force.
var acceleration = Vector2.ZERO

# Engine Property
var rpm = 0
var max_rpm = 7000
var rpm_decay = 50
var rpm_delay = 0.8 # Delay of rpm following gas input
var torque = 0

# Car Friction and Drag
# Friction Customizeable [-0.85,-0.95]
var counter_force = Vector2.ZERO
var friction = -0.9
var friction_force = Vector2.ZERO
var drag = -0.0003
var drag_force = Vector2.ZERO
var engine_brake = 0
var engine_brake_force = Vector2.ZERO

# Reverse and Brake
# Brake Power Customizeable [-1,-3]
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
	wheel_base = (get_node("CarCollision").get_polygon()[19].x - 30) - \
					get_node("CarCollision").get_polygon()[4].x + 30
	gear = gear_shift[gear_index]
	rear_wheel = position - transform.x * wheel_base / 2.0
	front_wheel = position + transform.x * wheel_base / 2.0
	new_heading = (front_wheel - rear_wheel).normalized()
	traction = traction_slow
	new_heading_dot = new_heading.dot(velocity.normalized())
	
	$EngineSound.volume_db += (get_node("/root/GameOption").get_volume())
	$EngineSoundSub.volume_db += (get_node("/root/GameOption").get_volume())
	$EngineSoundBass.volume_db += (get_node("/root/GameOption").get_volume())
	$Heartbeat.volume_db += (get_node("/root/GameOption").get_volume())
	
func _input(event):
	if event.is_action_pressed("ui_shift_up") || event.is_action_pressed("ui_shift_down"):
		if event.is_action_pressed("ui_shift_up"):
			gear_index = clamp(gear_index + 1, 0, gear_shift.size()-1)
		elif event.is_action_pressed("ui_shift_down"):
			gear_index = clamp(gear_index - 1, 0, gear_shift.size()-1)
		process_gear()
	if event.is_action_pressed("ui_toggle_light"):
		if light_switch:
			$FrontLamp.switch_light_off()
			light_switch = false
			get_node("/root/GameOption").set_volume(get_node("/root/GameOption").get_volume() - 30)
			$EngineSound.volume_db += 5
			$EngineSoundSub.volume_db += 5
			$EngineSoundBass.volume_db += 5
			$Heartbeat.play()
		else:
			$FrontLamp.switch_light_on()
			light_switch = true
			get_node("/root/GameOption").set_volume(get_node("/root/GameOption").get_volume() + 30)
			$EngineSound.volume_db -= 5
			$EngineSoundSub.volume_db -= 5
			$EngineSoundBass.volume_db -= 5
			$Heartbeat.stop()

func _physics_process(delta):
	#debug_print()
	acceleration = Vector2.ZERO
	counter_force = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	calculate_sound()
	# Here acceleration is already calculated in get_input() and apply_friction()
	# As there is no Force in CharacterBody2D, use velocity instead
	if counter_force.length() > acceleration.length() and velocity.is_zero_approx():
		velocity = Vector2.ZERO
	else:
		velocity += (acceleration + counter_force) / weight * delta
	move_and_slide()

func get_input():
	# Car Steering Wheel Data, Higher Turn -> Steering Wheel Turned More
	if enabled_input and Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		steering_weight = clamp(log(velocity.length()), 0, 99) * steering_weight_multiplier
		if is_mouse_and_keyboard:
			if Input.is_action_pressed("ui_right"):
				if turn < 0:
					turn = 0
				turn += (steering_angle/20.0)/steering_weight
				turn = clamp(turn, 0, steering_angle)
			if Input.is_action_pressed("ui_left"):
				if turn > 0:
					turn = 0
				turn -= (steering_angle/20.0)/steering_weight
				turn = clamp(turn, -steering_angle, 0)
			# Implement steering weight at velocity to reduce turn rate
			# At higher speed, log(velocity) is approx 3, minus 3 to get decimal and times 1.2 for more weight
			steer_angle = clamp(steer_angle + turn, \
				-steering_angle+(steering_angle*(steering_weight-3)*1.2), \
				steering_angle-(steering_angle*(steering_weight-3)*1.2))
		else:
			if Input.is_action_pressed("ui_right"):
				if turn < 0:
					turn = move_toward(turn, 0, steer_decay+(steer_decay*steering_weight_multiplier)*2)
				else:
					turn = Input.get_action_strength("ui_right") * steering_angle
			if Input.is_action_pressed("ui_left"):
				if turn > 0:
					turn = move_toward(turn, 0, steer_decay+(steer_decay*steering_weight_multiplier)*2)
				else:
					turn = -Input.get_action_strength("ui_left") * steering_angle
			steer_angle = clamp(turn, \
				-steering_angle+(steering_angle*(steering_weight-3)*1.2), \
				steering_angle-(steering_angle*(steering_weight-3)*1.2))
	else:
		steer_angle = move_toward(steer_angle, 0, steer_decay+(steer_decay*steering_weight_multiplier))
		turn = move_toward(turn, 0, steer_decay+(steer_decay*steering_weight_multiplier))
		
	if enabled_input and Input.is_action_pressed("ui_up"):
		if is_mouse_and_keyboard:
			gas = clamp(gas + gas_rate, 0, 1)
		else:
			gas = Input.get_action_strength("ui_up")
			Input.start_joy_vibration(0, gas*0.2, 0, 0.1)
	else:
		gas = move_toward(gas, 0, gas_rate)
	
	if gear_index == 1:
		# Revving system which increase RPM during neutral
		if enabled_input and Input.is_action_pressed("ui_up"):
			rpm_rev = clamp(rpm_rev + 0.1,0,1)
			rpm = clamp(_cubic_bezier(Vector2(0,0), Vector2(0.54,0.33), Vector2(0.41,1.35), \
									Vector2(1,1), rpm_rev).y, 0.2, 1) * max_rpm
		else:
			rpm = move_toward(rpm, 0, rpm_decay)
			rpm_rev = move_toward(rpm_rev, 0, rpm_decay)
	else:
		rpm = velocity.length() * gear_ratio[gear_index] * final_drive_ratio 
		# Limit the RPM within the limit
		if abs(rpm) > max_rpm:
			rpm = move_toward(rpm, max_rpm, abs(rpm)-max_rpm)
		# Actual power delivered with the RPM
		delivered_power = clamp(_cubic_bezier(Vector2(0,0), Vector2(0.54,0.33), Vector2(0.41,1.35), \
								Vector2(1,1), rpm/max_rpm).y, 0.2, 1) * engine_power + 50
		torque = gas * delivered_power * gear_effectivity
		# Adds acceleration penalty on lower RPM in higher gear
		# Also impacts lower gear but not that strong thanks to the gear index
		if abs(rpm) < 3000:
			torque *= gear_ratio[gear_index] * (1-_cubic_bezier(Vector2(0.1,0.1), \
					Vector2(0.93,0.05), Vector2(0.76,0.75), Vector2(1,1), rpm/max_rpm).y)
		acceleration = transform.x * torque
	
	if enabled_input and Input.is_action_pressed("ui_down"):
		if is_mouse_and_keyboard:
			counter_force += velocity * brake_power/clamp(log(velocity.length())-3,0.1,2)
		else:
			Input.start_joy_vibration(0, gas*0.2, 0, 0.1)
			counter_force += Input.get_action_strength("ui_down") * \
							velocity * brake_power/clamp(log(velocity.length())-3,0.1,2)

func process_gear():
	gear = gear_shift[gear_index]
	gear_effectivity = 0
	if gear_index > 1:
		for ratios in range(1, gear_index+1):
			# Current implementation: use acceleration penalty for low speed high gear
			# This implementation allows you to skip to high gear as it delivered full torque
			gear_effectivity += gear_ratio[ratios]
	else:
		gear_effectivity = -gear_ratio[gear_index]
	
func calculate_sound():
	tween = create_tween()
	tweenSub = create_tween()
	tweenBass = create_tween()
	tween.tween_property($EngineSound, "pitch_scale", clamp((clamp(rpm,1000,7000)/7000), 0.5, 2), 0.2).from_current()
	tweenSub.tween_property($EngineSoundSub, "pitch_scale", clamp((clamp(rpm,1000,7000)/5500), 0.5, 2), 0.2).from_current()
	tweenBass.tween_property($EngineSoundBass, "pitch_scale", clamp((clamp(rpm,1000,7000)/3500), 1, 1.5), 0.2).from_current()

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
	
	engine_brake = clamp(\
					(velocity.length() * gear_ratio[gear_index] * final_drive_ratio - max_rpm)/max_rpm \
					, 0, 1) * 0.5
	engine_brake_force = velocity * -engine_brake
	
	if velocity.length() < 100:
		friction_force *= 3
	elif velocity.length() > 500:
		friction_force *= 0.35
	
	# Flong += Frr + Fdrag
	counter_force += drag_force + friction_force + engine_brake_force
	
func reset_state():
	position = Vector2(0,0)
	gear_index = 1
	gear = gear_shift[gear_index]
	process_gear()
	gas = 0
	turn = 0
	acceleration = Vector2.ZERO
	counter_force = Vector2.ZERO
	steer_angle = 0
	torque = 0
	velocity = Vector2.ZERO
	rotation = 0

func debug_print():
	#print("TORQUE:", snapped(torque, 0.01), \
			#" RPM:", snapped(rpm, 0.01), " SPEED:", snapped(velocity.length(),0.01), \
			#" GEAR:", gear , \
			#" || ", \
	print(" PWR:", engine_power, \
			" GEAR:", gear_ratio, \
			" FINAL:", final_drive_ratio, \
			" ANGL:", steering_angle, \
			" STRWGT:", steering_weight_multiplier, \
			" WGT:", weight, \
			" FRT:", friction, \
			" BRK:", brake_power, \
			" ROT:", rotation)
			
			#" STRWGT:", steering_weight-3, \
			#" LOGVEL:", log(velocity.length()), \
			#" TURN:", turn, \
			#" STRANG:", steer_angle, \
			#" ASD:", steering_angle-(steering_angle*(steering_weight-3)*1.2) )
			#" GAS:", gas, \
			#" GEARODX:", gear_index, \
			#" NEWHEAD:", snapped(new_heading, 0.01), \
			#" NEWHEADD:", snapped(new_heading_dot, 0.01) )
			#" GREF:", gear_effectivity)
			#" ACC:", snapped(acceleration.length(), 0.01), \
			#" CTR:", snapped(counter_force.length(), 0.01), \
			#" BRK:", snapped((velocity * brake_power/clamp(log(velocity.length())-3,0.1,3)).length(), 0.01), \
			#" FR:", snapped(friction_force.length(), 0.01), \
			#" DRG:", snapped(drag_force.length(), 0.01))

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)
	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)
	var s = r0.lerp(r1, t)
	return s
