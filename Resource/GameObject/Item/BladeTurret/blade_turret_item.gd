extends UsableItem

@export var placed_turret_scene: PackedScene
@export var placement_offset_radius: float = 150
# Called when the node enters the scene tree for the first time.


func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	super.execute(use_global_position)
	var place_direction: Vector2 = (use_global_position - Instance.player.global_position).normalized()
	var placed_turret: Node2D = placed_turret_scene.instantiate()
	Instance.map.obstacle_container.add_child(placed_turret)
	placed_turret.global_position = Instance.player.global_position + place_direction * placement_offset_radius
	
	is_using = false
	
	consumed.emit()
