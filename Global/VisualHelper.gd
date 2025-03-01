extends Node2D


const DAMAGE_INDICATOR = preload("res://Scene/Base/damage_indicator.tscn")


func show_damage_indicator(damage: String, global_pos: Vector2):
	var damage_indicator = DAMAGE_INDICATOR.instantiate()
	damage_indicator.damage = damage
	Instance.map.add_child(damage_indicator)
	#add_child(damage_indicator)
	damage_indicator.global_position = global_pos
