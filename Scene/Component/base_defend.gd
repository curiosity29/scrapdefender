class_name BaseDefense
extends CharacterBody2D
@onready var health_bar: ColorRect = %HealthBar

@export var max_health: int = 300
# Called when the node enters the scene tree for the first time.
var hittable_interface: HittableInterface
func _ready() -> void:
	hittable_interface = HittableInterface.new(max_health, self)
	Instance.base_defend = self
	hittable_interface.stats_changed.connect(update_stats_visual)
	hittable_interface.dead_callback = on_dead

func on_dead():
	if Instance.map.is_won:
		return
	Instance.map.on_lose()
	
func update_stats_visual():
	health_bar.material.set_shader_parameter("pog_value", max(0.0, float(hittable_interface.health))/hittable_interface.max_health)
