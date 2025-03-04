class_name Enemy
extends CharacterBody2D

signal loot_dropped(item_resource: ItemResource, global_pos: Vector2)

@export_group("id")
@export var resource_id: String
var enemy_resource: EnemyResource
#region visual handle

@export_group("visual default")
@export var starting_look_direction: Vector2 = Vector2.LEFT
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var auto_flip_sprite: bool = true
#endregion

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D

@onready var hitbox: Area2D = %Hitbox

var hittable_interface: HittableInterface

@export_group("stats")
#@export var health: int = 20
var health: int = 20
@export var speed = 150.0
@export var attack_range: float = 30.
@export var damage: int = 5

@export_group("debug")
@export var target: Node2D:
	get:
		return Instance.base_defend if Instance.base_defend else self

func _ready() -> void:
	enemy_resource = Database.enemies_map[resource_id]
	hittable_interface = HittableInterface.new(health, self)
	health = enemy_resource.max_health
	
	
func _physics_process(delta: float) -> void:
	#region movement
	if target:
		nav_agent.target_position = target.global_position
		var target_pos = nav_agent.get_next_path_position()
		
		if target.global_position.distance_to(global_position) < attack_range:
			var target_hittable_interface: HittableInterface = target.get_meta("hittable_interface")
			target_hittable_interface.take_damage(damage, self)
			queue_free()
		
		var direction: Vector2 = (target_pos - global_position).normalized()
		velocity = direction * speed
		
		var do_flip: bool = auto_flip_sprite and (direction.x > 0)
		sprite_2d.flip_h = do_flip
		if do_flip: look_at(global_position + direction)
		else: look_at(global_position - direction)
		move_and_slide()
	#endregion


func _exit_tree() -> void:
	
	var random_loot: ItemResource = enemy_resource.get_loot()
	if random_loot:
		loot_dropped.emit(random_loot, global_position)
	pass
