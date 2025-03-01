extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

var damage: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = damage
	#animation_player.play("popup")
