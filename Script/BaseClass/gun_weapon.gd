class_name GunWeapon
extends Weapon

#region optional dependency
var bullet_parent: Node:
	get: return Instance.map
	#get: return get_tree().current_scene
#endregion

#region firing bullet

@export var bullet_scene: PackedScene
@export var fire_speed: float = 2.0;
var fire_timer: Timer = Timer.new();
@export var bullet_spawn_point: Node2D
#endregion

func _ready() -> void:
	super()
	fire_timer.wait_time = 1/fire_speed
	fire_timer.one_shot = true
	add_child(fire_timer)
	fire_timer.timeout.connect(
		func(): 
			is_using = false
	)

func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	rotation = (use_global_position - global_position).angle()
	
	
	if is_using:
		return
	
	super()
	var direction: Vector2 = (use_global_position - global_position).normalized()
	var new_bullet: Projectile = bullet_scene.instantiate()
	bullet_parent.add_child(new_bullet)
	new_bullet.global_position = bullet_spawn_point.global_position
	new_bullet.fire_self(direction)
	is_using = true
	fire_timer.start()
	
	
