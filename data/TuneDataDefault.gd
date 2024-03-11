extends Node

# Temporary Debug Value
var type_circ = 0
var temp_speed = 0
var is_mouse_and_keyboard = true

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


