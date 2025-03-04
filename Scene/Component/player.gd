class_name Player
extends CharacterBody2D

@onready var hurt_box: Area2D = %HurtBox
@onready var item_bar: ItemBar = %ItemBar
@onready var hand_position_handler: HandPositionHandler = %HandPositionHandler
@onready var inventory_ui: InventoryUI = %InventoryUI
@onready var inventory_component: Node2D = %InventoryComponent
@onready var craft_ui: CraftUI = %CraftUI
var null_item_id: String = "null_item"
var null_item_resource: ItemResource
var current_item_resource: ItemResource:
	set(value):
		current_item_resource = value
		if not current_item_resource:
			current_item_resource = null_item_resource
		
		current_item_id = current_item_resource.id
		
		#print("switching from %s to %s " % [current_item_id, item_resource.id])
		if current_item: current_item.queue_free()
		current_item = current_item_resource.scene.instantiate()
		current_hand.add_child(current_item)
		
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
		connect_single(current_item.start_using, func(): is_using_item = true)
		connect_single(current_item.start_using, func(): is_using_item = false)
		connect_single(current_item.consumed, item_bar.subtract_item.bind(
			Database.items_map[current_item.resource_id], 1
		))
		
func connect_single(input_signal: Signal, callable: Callable):
	if input_signal.is_connected(callable):
		return
	input_signal.connect(callable)
	
var current_item_id: String = ""

var is_using_item: bool = false:
	get:
		if not current_item: return false
		return is_using_item
		
@onready var energy_bar: ColorRect = %EnergyBar
var energy: float = 100.0:
	set(value):
		energy = clampf(value, 0., 100.)
		energy_bar.material.set_shader_parameter("pog_value", energy/100)
@export var auto_energy_consumption: float = 2.5

func _ready() -> void:
	Instance.player = self
	hittable_interface = HittableInterface.new(health, self)
	setup_craft_handling()
	
	null_item_resource = Database.items_map[null_item_id]
	item_bar.item_ran_out.connect(on_item_ran_out)
	update_survival_label()

	
@onready var visuals: Node2D = $Visuals

#var current_trail: Trail
#func make_trail():
	#if current_trail:
		#current_trail.stop()
	#var new_node: Node = Node.new()
	#add_child(new_node)
	#
	#current_trail =  Trail.create(new_node)

func on_item_ran_out(item_resource: ItemResource):
	if current_item_resource.id == item_resource.id:
		current_item_resource = null
func setup_craft_handling():
	craft_ui.request_craft.connect(on_craft_request)
	pass
func on_craft_request(recipe: Dictionary[String, int], result: String):
	if inventory_ui.check_remove(recipe):
		item_bar.add_item(Database.items_map[result])
		
		
	
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("click"):
		if current_item and current_item.holdable and not is_using_item:
			update_hand()
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
		update_hand()
		
		#if current_item and not (current_hand.get_parent() == current_hand):
			#current_item.reparent(current_hand, false)
		if current_item and not current_item.holdable and not is_using_item:
			current_item.execute()
	if event.is_action_pressed("toggle_inventory"):
		inventory_component.visible = !inventory_component.visible
		
	if event.is_action_pressed("interact"):
		energy += 20
		#make_trail()
		
	for keybind_name: String in item_bar.keybind_to_item_resource:
		if event.is_action_pressed(keybind_name):
			var item_resource: ItemResource = item_bar.keybind_to_item_resource[keybind_name]
			#if not item_resource: 
				#item_resource = null_item_resource
			if item_resource and (item_resource.id == current_item_id): break
			current_item_resource = item_resource
			break
	#if event.is_action_released("click"):
		#is_using_item = false
		#current_item.stop_executing()
	pass

func update_hand():
	var use_angle: float = _get_global_use_angle()
		
	current_hand = hand_position_handler.get_hand_by_angle(use_angle)
	if current_item:
		current_item.flip_h(hand_position_handler.do_flip_h)
	
func _get_global_use_angle() -> float:
	return rad_to_deg((get_global_mouse_position() - current_hand.global_position).angle())



@onready var survival_timer_label: RichTextLabel = $SurviveStats/SurvivalTimerLabel

@export var survival_current_second: int = 180
var survival_timer_label_text_format = \
"""SURVIVE FOR:
%d min %d sec"""
func _on_survival_second_timer_timeout() -> void:
	update_survival_label()
func update_survival_label():
	survival_current_second -= 1
	var minute: int = survival_current_second / 60
	var second: int = survival_current_second % 60
	survival_timer_label.text = survival_timer_label_text_format % [minute, second]


@onready var phase_timer_label: RichTextLabel = $SurviveStats/PhaseTimerLabel

func update_phase_timer_label(string: String):
	phase_timer_label.text = string


@onready var win_label: RichTextLabel = $WinLabel/WinLabel
@onready var lose_label: RichTextLabel = $WinLabel/LoseLabel

func show_win_label():
	win_label.show()
func show_lose_label():
	lose_label.show()
