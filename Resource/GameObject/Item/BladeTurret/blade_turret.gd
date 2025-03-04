extends Node2D


@onready var trail_point_1: Node2D = %TrailPoint1
@onready var trail_point_2: Node2D = %TrailPoint2
@onready var trail_point_3: Node2D = %TrailPoint3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_trail()


func make_trail():
	
	for trail_point in [trail_point_1, trail_point_2, trail_point_3]:
		
		var new_node: Node = Node.new()
		add_child(new_node)
		var new_trail =  Trail.create(trail_point, 8, 50)
		new_node.add_child(new_trail)
