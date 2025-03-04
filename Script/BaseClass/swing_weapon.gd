class_name SwingWeapon
extends Weapon


#@export var hold_position_offset: Vector2


	
var swing_rotation: float = PI/6:
	set(value):
		swing_rotation = value
		rotation = swing_rotation

@export var default_offset_angle = -90

@export var attack_speed: float = 1.0
#@export var default_swing_rotation_degree: float = 210
@export var default_over_rotation_degree: float = 90
var swing_rotation_degree: float = 20:
	set(value):
		swing_rotation_degree = value
		swing_rotation = swing_rotation_degree / 180 * PI

func swing(target_angle: float, clockwise: bool = true, enable_on_finish: bool = true):
	#if angle < 1.0:
		#swing_rotation_degree += angle
	#else:
	var tween = create_tween()
	var old_rotation_degree: float = swing_rotation_degree
	tween.tween_property(self, "swing_rotation_degree", target_angle, abs(target_angle - swing_rotation_degree) / 360 / attack_speed)
	tween.finished.connect(
		func(): 
			swing_rotation_degree = old_rotation_degree
			if enable_on_finish: is_using = false
	)
		

func execute(use_global_position: Vector2 = get_global_mouse_position()) -> void:
	# already in use
	if is_using: return
	
	super.execute(use_global_position)
	
	# failed check to use
	if not is_using: return
	
	var use_angle: float = rad_to_deg((use_global_position - global_position).angle()) - default_offset_angle
	
	#print("target angle: ", use_angle)
	var clock_wise: bool = use_angle > swing_rotation_degree
	#var target_angle: float = use_angle + default_over_rotation_degree if clock_wise else use_angle - default_over_rotation_degree
	var target_angle: float = 360
	swing(target_angle, clock_wise)
		
func _ready() -> void:
	super()
	swing_rotation_degree = init_hand_rotation_degree
