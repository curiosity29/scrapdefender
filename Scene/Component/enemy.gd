class_name Enemy
extends CharacterBody2D

@onready var hitbox: Area2D = %Hitbox

@export var speed = 150.0
var hittable_interface: HittableInterface
@export var health: int = 100

@export var target: Node2D:
	get:
		return Instance.base_defend if Instance.base_defend else null

func _ready() -> void:
	hittable_interface = HittableInterface.new(health, self)
	
	
func _physics_process(delta: float) -> void:
	#region movement
	if target:
		var direction: Vector2 = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	#endregion
