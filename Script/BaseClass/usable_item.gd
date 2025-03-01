class_name UsableItem
extends Node2D

signal start_using
signal stop_using

func is_using_setter(value):
	if is_using and not value:
		stop_using.emit()
	if not is_using and value:
		start_using.emit()
	is_using = value

@export var init_hand_offset: Vector2
@export var init_hand_rotation_degree: float = 0
@export var holdable: bool = false

var is_using: bool = false: set = is_using_setter


func _ready():
	pass

func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	is_using = true


func stop_executing():
	is_using = false
