class_name ItemBar
extends HBoxContainer

var keybind_to_item_resource: Dictionary[String, ItemResource]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: ItemIndicator in get_children():
		keybind_to_item_resource[child.label_text] = child.item_resource


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
