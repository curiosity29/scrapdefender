class_name ItemBar
extends HBoxContainer

signal item_ran_out(item_resource: ItemResource)

var usage_bar_button_group: ButtonGroup = preload("res://Resource/Misc/usage_bar_button_group.tres")
var keybind_to_item_resource: Dictionary[String, ItemResource]
# Called when the node enters the scene tree for the first time.
func subtract_item(item_resource: ItemResource, count: int = 1):
	## stacking
	for child: ItemIndicator in get_children():
		if not child.item_resource: continue
		if item_resource.id == child.item_resource.id:
			child.stack_count = max(0, child.stack_count - count)
			if child.stack_count <= 0:
				item_ran_out.emit(item_resource)
	
func add_item(item_resource: ItemResource, count: int = 1):
	var is_stacked: bool = false
	## stacking
	for child: ItemIndicator in get_children():
		if not child.item_resource: continue
		if item_resource.id == child.item_resource.id:
			child.stack_count += count
			is_stacked = true
			return
	
	## add new
	for child: ItemIndicator in get_children():
		if not child.item_resource:
			child.item_resource = item_resource
			keybind_to_item_resource[child.label_text] = child.item_resource
			break

func _ready() -> void:
	for child: ItemIndicator in get_children():
		keybind_to_item_resource[child.label_text] = child.item_resource
		child.button_group = usage_bar_button_group

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
