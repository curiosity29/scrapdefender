class_name InventoryUI
extends Node2D

@onready var grid_container: GridContainer = %GridContainer

var items: Dictionary[String, Dictionary] = {
	#"scrap": {
		#"count": 1,
		#"cell_id": Vector2i(0,0)
	#}
}

var cell2items: Dictionary[Vector2i, String] = {
	#Vector2i(0,0): "scrap"
}

@export var inventory_shape: Vector2i = Vector2i(10, 4)

var label_string_format: String = "%s (x%d)"

func check_remove(item_count: Dictionary[String, int], remove_on_success: bool = true) -> bool:
	for item_id in item_count:
		if item_count[item_id] > items[item_id]["count"]:
			return false
	if remove_on_success:
		for item_id in item_count:
			items[item_id]["count"] -= item_count[item_id]
			update_cell_visual(items[item_id]["cell_id"])
	#update_visual_all_cells()
	return true
func update_visual_all_cells():
	for x in range(inventory_shape.x):
		for y in range(inventory_shape.y):
			update_cell_visual(Vector2i(x, y))
	
func add_item(id: String, count: int = 1):
	if id in items:
		var current_data: Dictionary = items[id]
		current_data["count"] += count
		update_cell_visual(current_data["cell_id"])
	else:
		## so lazy man
		var has_empty_cell: bool = false
		var first_empty_cell: Vector2i = Vector2i.ZERO
		for x in range(inventory_shape.x):
			for y in range(inventory_shape.y):
				if Vector2i(x, y) not in cell2items:
					first_empty_cell = Vector2i(x, y)
					has_empty_cell = true
					break
			if has_empty_cell:
				break
		if has_empty_cell:
			items[id] = {
				"count": count,
				"cell_id": first_empty_cell
			}
			cell2items[first_empty_cell] = id
			update_cell_visual(first_empty_cell)
			
func update_cell_visual(cell_id: Vector2i):
	var item_indicator: ItemIndicator = grid_container.get_child(cell_id.x + cell_id.x * inventory_shape.y)
	var item_id = cell2items[cell_id]
	var item_resource: ItemResource = Database.items_map[item_id]
	item_indicator.label.text = label_string_format % [item_id, items[item_id]["count"]]
	item_indicator.icon.texture = item_resource.icon
# Called when the node enters the scene tree for the first time.
var inventory_button_group = preload("res://Resource/Misc/inventory_button_group.tres")
func _ready() -> void:
	for child: ItemIndicator in grid_container.get_children():
		child.button_group = inventory_button_group
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
