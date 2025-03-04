class_name Projectile
extends Node2D

@export var move_speed: float = 1000.0
var fire_direction: Vector2 = Vector2.ZERO

#func _ready() -> void:
	

func fire_self(direction: Vector2) -> void:
	fire_direction = direction
	rotation = direction.angle()
	make_trail()


func _process(delta: float) -> void:
	if fire_direction:
		global_position += fire_direction * move_speed * delta
	
	check_out_of_screen()



func check_out_of_screen() -> void:
	if min(global_position.x, global_position.y) <-1000 or max(global_position.x, global_position.y) > 3000:
		queue_free()


var current_trail: Trail
func make_trail():
	if current_trail:
		current_trail.stop()
	var new_node: Node = Node.new()
	add_child(new_node)
	
	current_trail =  Trail.create(self, 10, 50)
	new_node.add_child(current_trail)
