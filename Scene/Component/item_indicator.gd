class_name ItemIndicator
extends Control

signal item_selected(ItemResource)
@onready var select_button: Button = $SelectButton

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label
@onready var style_label: Label = %StyleLabel
@onready var stack_count_label: Label = $MarginContainer/VBoxContainer/Icon/StackCountLabel

@export var button_group: ButtonGroup:
	set(value):
		button_group = value
		if is_node_ready(): select_button.button_group = button_group
@export var default_style_box: StyleBoxFlat
@export var selected_style_box: StyleBoxFlat
var stack_count: int = 1:
	set(value):
		stack_count = value
		if stack_count> 1:
			stack_count_label.text = str(stack_count)
		elif stack_count <=0:
			item_resource = null
		else:
			stack_count_label.text = ""
@export var label_text: String = ""
@export var item_resource: ItemResource:
	set(value):
		item_resource = value
		if not item_resource: 
			if not is_node_ready():
				return
			else:
				icon.texture = null
				return
		if not is_node_ready():
			ready.connect(func(): item_resource = item_resource, CONNECT_ONE_SHOT)
			return
		icon.texture = item_resource.icon
		
var is_selected: bool = false:
	set(value):
		is_selected = value
		#print(is_selected)
		if is_selected:
			style_label.add_theme_stylebox_override("normal", selected_style_box)
			item_selected.emit(item_resource)
		else:
			style_label.add_theme_stylebox_override("normal", default_style_box)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text
	label.add_theme_stylebox_override("normal", default_style_box)
	




func _on_select_button_toggled(toggled_on: bool) -> void:
	is_selected = toggled_on
