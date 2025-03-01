class_name ItemLootDrop
extends Node2D

signal item_picked_up(ItemResource)

@onready var sprite_2d: Sprite2D = $Sprite2D

var item_resource: ItemResource:
	set(value):
		item_resource = value
		if is_node_ready():
			sprite_2d.texture = item_resource.icon
@export var resource_id: String:
	set(value):
		item_resource = Database.items_map[resource_id]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("loot dropped", item_resource)
	if item_resource: 
		sprite_2d.texture = item_resource.icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickup_area_body_entered(body: Node2D) -> void:
	item_picked_up.emit(item_resource)
	queue_free()
