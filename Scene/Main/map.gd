class_name Map
extends Control

@onready var spawners: Node2D = $Spawners
@onready var loot_container: Node2D = %LootContainer

@export var spawn_timer: Timer = Timer.new()
@export var spawn_speed: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance.map = self
	
	#drop_loot(Database.items_map["scrap"], global_position)
	
	setup_spawn()
	debug_init()
	
func setup_spawn():
	spawn_timer.wait_time = spawn_speed
	spawn_timer.timeout.connect(random_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()
	





func random_spawn_enemy():
	var random_spawner: Control = spawners.get_children().pick_random()
	var random_pos: Vector2 = random_spawner.global_position + Vector2(randi_range(0, random_spawner.size.x), randi_range(0, random_spawner.size.y))
	var new_enemy: Enemy = Database.enemies_map["walker"].scene.instantiate()
	new_enemy.loot_dropped.connect(drop_loot)
	
	Instance.map.add_child(new_enemy)
	new_enemy.global_position = random_pos
	
	
@onready var wtf: Node2D = $Wtf

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
