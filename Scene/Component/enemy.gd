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


@onready var hitbox: Area2D = %Hitbox

@export var speed = 150.0
var hittable_interface: HittableInterface

@export_group("stats")
@export var health: int = 20

@export_group("debug")
@export var target: Node2D:
	get:
		return Instance.base_defend if Instance.base_defend else self

func _ready() -> void:
	enemy_resource = Database.enemies_map[resource_id]
	hittable_interface = HittableInterface.new(health, self)
	
	
func _physics_process(delta: float) -> void:
	#region movement
	if target:
		var direction: Vector2 = (target.global_position - global_position).normalized()
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
