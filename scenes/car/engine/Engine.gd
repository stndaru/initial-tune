extends Node2D

# Car Engine Data
var engine_power = 500  # Forward acceleration force.
var acceleration = Vector2.ZERO

# Engine Property
var rpm = 0
var max_rpm = 7
var rpm_decay = 0.5
var rpm_delay = 0.8 # Delay of rpm following gas input
var torque = 0
