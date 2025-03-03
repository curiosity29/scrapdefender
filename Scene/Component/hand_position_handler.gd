class_name HandPositionHandler
extends Node2D

@export var left_hand: Node2D
@export var right_hand: Node2D
#@export var up_hand: Node2D
#@export var down_hand: Node2D

@export var do_flip_h: bool = false

@export var current_hand: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_hand_by_angle(angle: float) -> Node2D:
	if abs(angle) < 90:
		do_flip_h = false
	else:
		do_flip_h = true
	
	return current_hand
	#if -135 <= angle and angle < -45:
		#return up_hand
	#elif -45 <= angle and angle < 45:
		#return right_hand 
	#elif 45 <= angle and angle < 135:
		#return down_hand  
	#else:
		#return left_hand  
