class_name Player
extends CharacterBody2D

@onready var hurt_box: Area2D = %HurtBox
@onready var item_bar: ItemBar = %ItemBar
@onready var hand_position_handler: HandPositionHandler = %HandPositionHandler
@onready var inventory_ui: InventoryUI = %InventoryUI

@export var current_hand: Node2D
@export var speed = 600.0
@export var brake_speed: float = 2000.
var hittable_interface: HittableInterface
@export var health: int = 100
@export var current_item: UsableItem:
	set(value):
		is_using_item = false
		current_item = value
		if not current_item: return
		## NOTE: potential multiple connect
		current_item.start_using.connect(func(): is_using_item = true)
		current_item.stop_using.connect(func(): is_using_item = false)
var current_item_id: String = ""

var is_using_item: bool = false:
	get:
		if not current_item: return false
		return is_using_item
		
@onready var energy_bar: ColorRect = $Stats/Control/MarginContainer/EnergyBar
var energy: float = 100.0:
	set(value):
		energy = value
		energy_bar.material.set_shader_parameter("pog_value", energy/100)
@export var auto_energy_consumption: float = 2.5

func _ready() -> void:
	Instance.player = self
	hittable_interface = HittableInterface.new(health, self)

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("click"):
		if current_item and current_item.holdable and not is_using_item:
			current_item.execute()
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		#velocity = move_toward(velocity, direction * SPEED, SPEED)
		
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, brake_speed)

	move_and_slide()
	
	energy -= auto_energy_consumption * delta


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var use_angle: float = _get_global_use_angle()
		current_hand = hand_position_handler.get_hand_by_angle(use_angle)
		if current_item and not (current_hand.get_parent() == current_hand):
			current_item.reparent(current_hand, false)
		if current_item and not current_item.holdable and not is_using_item:
			current_item.execute()
	if event.is_action_pressed("toggle_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		
	for keybind_name: String in item_bar.keybind_to_item_resource:
		if event.is_action_pressed(keybind_name):
			var item_resource: ItemResource = item_bar.keybind_to_item_resource[keybind_name]
			if not item_resource: continue
			if item_resource.id == current_item_id: break
			#print("switching from %s to %s " % [current_item_id, item_resource.id])
			current_item_id = item_resource.id
			if current_item: current_item.queue_free()
			current_item = item_resource.scene.instantiate()
			current_hand.add_child(current_item)
			break
	#if event.is_action_released("click"):
		#is_using_item = false
		#current_item.stop_executing()
	pass

	
func _get_global_use_angle() -> float:
	return rad_to_deg((get_global_mouse_position() - current_hand.global_position).angle())
