extends SwingWeapon

@onready var damage_area: DamageArea = %DamageArea

func _ready() -> void:
	super()
	damage_area.monitoring = false
	
	start_using.connect(on_start_using)
	stop_using.connect(on_stop_using)
	
	make_trail()
	
	
func on_start_using():
	damage_area.monitoring = true
	
func on_stop_using():
	damage_area.monitoring = false
	
	
@onready var top_point: Node2D = $TopPoint
@onready var bottom_point: Node2D = $BottomPoint


func make_trail():
	var new_node: Node = Node.new()
	add_child(new_node)
	
	var new_top_trail =  Trail.create(top_point, 8, 10)
	var new_bottem_trail =  Trail.create(bottom_point, 8, 10)
	new_node.add_child(new_top_trail)
	new_node.add_child(new_bottem_trail)
