extends Node

var _all_enemies: ResourceGroup = preload("res://Resource/Management/ResourceGroup/all_enemies.tres")
var all_enemies: Array[EnemyResource]
var enemies_map: Dictionary[String, EnemyResource]

func _ready() -> void:
	_all_enemies.load_all_into(all_enemies)
	for enemy_resource: EnemyResource in all_enemies:
		enemies_map[enemy_resource.id] = enemy_resource
