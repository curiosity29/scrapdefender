class_name Player
extends CharacterBody2D

@onready var hurt_box: Area2D = %HurtBox

@export var speed = 300.0
var hittable_interface: HittableInterface
@export var health: int = 100

func _ready() -> void:
	hittable_interface = HittableInterface.new(health, self)

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		#velocity = move_toward(velocity, direction * SPEED, SPEED)
		
		velocity = direction * speed

	move_and_slide()
