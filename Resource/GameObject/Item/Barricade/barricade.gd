extends UsableItem

@export var placed_barricade_scene: PackedScene
@export var placement_offset_radius: float = 150

	
	
func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	super.execute(use_global_position)
	var place_direction: Vector2 = (use_global_position - Instance.player.global_position).normalized()
	var placed_barricade: Node2D = placed_barricade_scene.instantiate()
	Instance.map.obstacle_container.add_child(placed_barricade)
	placed_barricade.global_position = Instance.player.global_position + place_direction * placement_offset_radius
	
	is_using = false
	
	consumed.emit()
