class_name ItemIndicator
extends Control

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label


@export var label_text: String = ""
@export var item_resource: ItemResource:
	set(value):
		item_resource = value
		if not item_resource: return
		if not is_node_ready():
			ready.connect(func(): item_resource = item_resource, CONNECT_ONE_SHOT)
			return
		icon.texture = item_resource.icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text
