extends UsableItem

@export var recharge_speed: float = 4.0
@onready var hitbox: Area2D = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	# already in use
	if is_using: return
	
	super.execute(use_global_position)
	
	# failed check to use
	if not is_using: return
	rotation = (use_global_position - global_position).angle()
	
	if Instance.base_defend in hitbox.get_overlapping_bodies():
		Instance.player.energy += recharge_speed * get_physics_process_delta_time()
	
	is_using = false
		
