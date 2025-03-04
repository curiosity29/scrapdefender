extends Node2D
@onready var bullet_spawn_point: Node2D = $BulletSpawnPoint

@export var bullet_scene: PackedScene
var current_angle: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func execute() -> void:
	
	var direction: Vector2 = Vector2.RIGHT.rotated(deg_to_rad(current_angle))
	current_angle += 10
	var new_bullet: Projectile = bullet_scene.instantiate()
	Instance.map.add_child(new_bullet)
	new_bullet.global_position = bullet_spawn_point.global_position
	new_bullet.fire_self(direction)

func _on_auto_fire_timer_timeout() -> void:
	execute()
