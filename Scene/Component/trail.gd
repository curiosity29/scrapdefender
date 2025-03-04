class_name Trail
extends Line2D

@export var max_points: int = 60
@onready var curve := Curve2D.new()
static var scene: PackedScene = preload("res://Scene/Component/trail.tscn")
var tracking_node: Node2D
@export var curve_width: float = 10
@export var stay_duration: float = 0.3
var start_offset: Vector2
func _ready() -> void:
	width = curve_width
	#start_offset = tracking_node.global_position
	#start_offset = tracking_node.position
	#start_offset = Vector2.ZERO
func _process(delta: float) -> void:
	#global_rotation = 0
	if not tracking_node: return
	var new_point: Vector2 = tracking_node.global_position #- start_offset
	#var new_point: Vector2 = get_parent().position# - start_offset
	#new_point = Vector2.ZERO
	curve.add_point(new_point)
	#curve.add_point(Vector2.ZERO)
	#print(new_point)
	if curve.get_baked_points().size() > max_points:
		curve.remove_point(0)
	points = curve.get_baked_points()

func stop() -> void:
	set_process(false)
	var tw := get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, stay_duration)
	await tw.finished
	queue_free()

static func create(init_tracking_node: Node2D, init_curve_width: float = 10, init_max_point: int = 30) -> Trail:
	var new_trail: Trail = scene.instantiate()
	new_trail.tracking_node = init_tracking_node
	new_trail.curve_width = init_curve_width
	new_trail.max_points = init_max_point
	return new_trail
