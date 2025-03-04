class_name ItemResource
extends Resource

@export_group("id")
@export var id: String
@export var item_name: String
@export var description: String

@export_group("component")
@export var icon: Texture
@export var scene: PackedScene

@export var recipe: Dictionary[String, int]
