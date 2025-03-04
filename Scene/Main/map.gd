class_name Map
extends Control



@onready var obstacle_container: Node2D = %ObstacleContainer
@onready var countdown_timer: Timer = $Node2D/CountdownTimer

@onready var spawners: Node2D = $Spawners
@onready var loot_container: Node2D = %LootContainer
@onready var phase_timer: Timer = %PhaseTimer
@onready var midphase_timer: Timer = %MidphaseTimer

var spawn_timer: Timer = Timer.new()
@export var spawn_speed: float = 0.7
var is_during_phase: bool = true
var time_till_next_event: float
var current_phase_count: int = 1
# Called when the node enters the scene tree for the first time.
var is_won: bool = false

		
func _ready() -> void:
	Instance.map = self
	#phase_start.connect(update_phase_label)
	#phase_stop.connect(update_phase_label)
	#drop_loot(Database.items_map["scrap"], global_position)
	
	setup_spawn()
	debug_init()
	
func on_lose():
	countdown_timer.stop()
	is_won = false
	Instance.player.show_lose_label()

func on_win():
	countdown_timer.stop()
	is_won = true
	Instance.player.show_win_label()
	
func setup_spawn():
	spawn_timer.wait_time = spawn_speed
	spawn_timer.timeout.connect(random_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()
	
	phase_timer.start()
	time_till_next_event = phase_timer.wait_time

func next_phase():
	current_phase_count += 1
	if current_phase_count > 4:
		on_win()
		return
		
	is_during_phase = true
	spawn_timer.wait_time *= 0.75
	spawn_timer.start()
	phase_timer.start()
	Database.enemies_map["walker"].max_health *= 1.7
	time_till_next_event = phase_timer.wait_time
	countdown_timer.start()

func stop_phase():
	is_during_phase = false
	time_till_next_event = midphase_timer.wait_time
	spawn_timer.stop()
	
	midphase_timer.start()
	countdown_timer.start()
	

func _on_midphase_timer_timeout() -> void:
	next_phase()

func _on_phase_timer_timeout() -> void:
	stop_phase()

func random_spawn_enemy():
	var random_spawner: Control = spawners.get_children().pick_random()
	var random_pos: Vector2 = random_spawner.global_position + Vector2(randi_range(0, random_spawner.size.x), randi_range(0, random_spawner.size.y))
	var new_enemy: Enemy = Database.enemies_map["walker"].scene.instantiate()
	new_enemy.loot_dropped.connect(drop_loot)
	
	Instance.map.add_child(new_enemy)
	new_enemy.global_position = random_pos
	
	

func drop_loot(item_resource: ItemResource, global_pos: Vector2):
	var new_loot_scene: ItemLootDrop = Database.item_loot_scene.instantiate()
	new_loot_scene.item_resource = item_resource
	loot_container.add_child(new_loot_scene)
	new_loot_scene.item_picked_up.connect(add_item_to_inventory)
	new_loot_scene.global_position = global_pos
	## NOTE: idk why tf directly add_child to this node is not ok but it's ok using a child Node2D
	#print(new_loot_scene)
	#print(new_loot_scene.get_parent())
	#print("creating loot at ", global_pos)
	#

func add_item_to_inventory(item_resource: ItemResource):
	Instance.player.inventory_ui.add_item(item_resource.id)
	


#region debug

@onready var enemies: Node2D = $Container/Enemies
func debug_init():
	for enemy: Enemy in enemies.get_children():
		enemy.loot_dropped.connect(drop_loot)
		
		
@onready var navigation_region_2d: NavigationRegion2D = %NavigationRegion2D
func _on_obstacle_container_child_order_changed() -> void:
	navigation_region_2d.call_deferred("bake_navigation_polygon")


func _on_countdown_timer_timeout() -> void:
	time_till_next_event -= 1
	time_till_next_event = max(0, time_till_next_event)
	if is_during_phase:
		Instance.player.update_phase_timer_label(
		"""current phase:\n%d sec left""" % int(time_till_next_event)
		)
	
	else:
		Instance.player.update_phase_timer_label(
		"""next phase:\n%d sec left""" % int(time_till_next_event)
		)
	
