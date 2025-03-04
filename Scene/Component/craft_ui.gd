class_name CraftUI
extends Node2D

signal request_craft(recipe: Dictionary[String, int], result: String)

var craft_ingredient_button_group: ButtonGroup = preload("res://Resource/Misc/craft_ingredient_button_group.tres")
var craft_bar_button_group: ButtonGroup = preload("res://Resource/Misc/craft_bar_button_group.tres")
# Called when the node enters the scene tree for the first time.

@onready var ingredient_container: HBoxContainer = %IngredientContainer
@onready var recipe_container: GridContainer = %RecipeContainer
var selected_item_indicator: ItemIndicator

func _ready() -> void:
	## NOTE: debug implement
	#region 
	var recipe_index: int = 0
	for item_resource: ItemResource in Database.all_items:
		if not item_resource.recipe.is_empty():
			var recipe_indicator: ItemIndicator = recipe_container.get_child(recipe_index)
			recipe_indicator.item_resource = item_resource
			recipe_index += 1
	#endregion
	for child: ItemIndicator in ingredient_container.get_children():
		child.button_group = craft_ingredient_button_group
		
		
	for child: ItemIndicator in recipe_container.get_children():
		child.button_group = craft_bar_button_group
		child.item_selected.connect(_on_recipe_selected.bind(child))

func _on_recipe_selected(item_resource: ItemResource, item_indicator: ItemIndicator):
	## NOTE: debug implement
	
	if not item_resource or item_resource.recipe.is_empty():
		return
		
	var ingredient_indicator: ItemIndicator = ingredient_container.get_child(0)
	var item_recipe_key: String = item_resource.recipe.keys()[0]
	var ingredient_count: int = item_resource.recipe[item_recipe_key]
	ingredient_indicator.item_resource = Database.items_map[item_recipe_key]
	ingredient_indicator.stack_count = ingredient_count
	selected_item_indicator = item_indicator
	


func _on_craft_button_pressed() -> void:
	## NOTE: debug implement
	if selected_item_indicator:
		request_craft.emit(selected_item_indicator.item_resource.recipe, selected_item_indicator.item_resource.id)
	
