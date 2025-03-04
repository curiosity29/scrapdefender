class_name UsableItem
extends Node2D

signal start_using
signal stop_using
signal consumed

@export var resource_id: String

func is_using_setter(value):
	if is_using and not value:
		stop_using.emit()
	if not is_using and value:
		start_using.emit()
	is_using = value

@export var execute_energy: float = 1.0
@export var init_hand_offset: Vector2
@export var init_hand_rotation_degree: float = 0
@export var holdable: bool = false

var is_using: bool = false: set = is_using_setter

var is_flip_h: bool = false: set = flip_h

func flip_h(do_flip: bool = true) -> void:
	is_flip_h = do_flip
	pass

func _ready():
	
	pass

func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	if Instance.player.energy< execute_energy:
		return
	Instance.player.energy -= execute_energy
	is_using = true
	

func stop_executing():
	is_using = false
