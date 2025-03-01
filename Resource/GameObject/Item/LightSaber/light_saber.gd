extends SwingWeapon

@onready var damage_area: DamageArea = %DamageArea

func _ready() -> void:
	super()
	damage_area.monitoring = false
	
	start_using.connect(on_start_using)
	stop_using.connect(on_stop_using)
	
	
func on_start_using():
	damage_area.monitoring = true
	
func on_stop_using():
	damage_area.monitoring = false
