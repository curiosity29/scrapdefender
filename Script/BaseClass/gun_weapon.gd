class_name GunWeapon
extends Weapon

@onready var sprite_2d: Sprite2D = %Sprite2D

#region optional dependency
var bullet_parent: Node:
	get: return Instance.map
	#get: return get_tree().current_scene
#endregion

#region firing bullet

func flip_h(do_flip: bool = true) -> void:
	super.flip_h(do_flip)
	sprite_2d.flip_h = do_flip

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
	# already in use3221
	if is_using: return
	
	super.execute(use_global_position)
	
	# failed check to use
	if not is_using: return
	rotation = (use_global_position - global_position).angle() + int(is_flip_h) * PI
	
	var direction: Vector2 = (use_global_position - global_position).normalized()
	var new_bullet: Projectile = bullet_scene.instantiate()
	bullet_parent.add_child(new_bullet)
	new_bullet.global_position = bullet_spawn_point.global_position
	new_bullet.fire_self(direction)
	is_using = true
	fire_timer.start()
	
	
