class_name EnemyResource
extends Resource


@export var id: String
@export var scene: PackedScene

@export var enemy_name: String

@export var max_health: int = 20

@export var drop_chance: float = 0.6

@export var loot_weights: Dictionary[ItemResource, float]

var accum_weights: Dictionary[ItemResource, float]


func setup():
	accum_weights = get_accum_weight(loot_weights)

func get_accum_weight(dict: Dictionary[ItemResource, float]) -> Dictionary[ItemResource, float]:
	var result_accum_weights: Dictionary[ItemResource, float]
	var weight_sum: float = 0
	for key in dict:
		weight_sum += dict[key]
		result_accum_weights[key] = weight_sum
	return result_accum_weights
		
func get_loot() -> ItemResource:
	
	if randf() < drop_chance and not accum_weights.is_empty():
		var random_weight: float = randi_range(0, accum_weights.values()[accum_weights.size()-1])
		var chosen_key: ItemResource
		for key in accum_weights:
			var value = accum_weights[key]
			if random_weight < value:
				chosen_key = key
		
		return chosen_key
	else:
		return null
