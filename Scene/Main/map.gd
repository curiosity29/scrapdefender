class_name Map
extends Control

@onready var spawners: Node2D = $Spawners

@export var spawn_timer: Timer = Timer.new()
@export var spawn_speed: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance.map = self
	
	setup_spawn()
	
func setup_spawn():
	spawn_timer.wait_time = spawn_speed
	spawn_timer.timeout.connect(random_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func random_spawn_enemy():
	var random_spawner: Control = spawners.get_children().pick_random()
	var random_pos: Vector2 = random_spawner.global_position + Vector2(randi_range(0, random_spawner.size.x), randi_range(0, random_spawner.size.y))
	var new_enemy = Database.enemies_map["john_godot"].scene.instantiate()
	
	Instance.map.add_child(new_enemy)
	new_enemy.global_position = random_pos
	
