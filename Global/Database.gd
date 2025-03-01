extends Node

var _all_enemies: ResourceGroup = preload("res://Resource/Management/ResourceGroup/all_enemies.tres")
var all_enemies: Array[EnemyResource]
var enemies_map: Dictionary[String, EnemyResource]

var _all_items: ResourceGroup = preload("res://Resource/Management/ResourceGroup/all_items.tres")
var all_items: Array[ItemResource]
var items_map: Dictionary[String, ItemResource]

func _ready() -> void:
	_all_enemies.load_all_into(all_enemies)
	for enemy_resource: EnemyResource in all_enemies:
		enemies_map[enemy_resource.id] = enemy_resource
		enemy_resource.setup()


	_all_items.load_all_into(all_items)
	for item_resource: ItemResource in all_items:
		items_map[item_resource.id] = item_resource
		#enemy_resource.setup()



var item_loot_scene = preload("res://Scene/Component/item_loot_drop.tscn")
