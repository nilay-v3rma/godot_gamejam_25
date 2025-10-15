extends Node
class_name FurnitureDB

var furnitures: Dictionary = {}

func _ready() -> void:
	for i in range(1, 4):
		_register_furniture("res://furniture/furniture data/furniture"+str(i)+".tres")

func _register_furniture(path: String):
	print("attemping to register: "+ path)
	var furniture: FurnitureData = load(path)
	furnitures[furniture.id] = furniture
	print(furniture.id, furniture.name)

func get_furniture(id: int) -> FurnitureData:
	print("Attempting to get furniture id:", str(id))
	return furnitures.get(id)

func get_scene_path(id: int) -> String:
	return furnitures.get(id).scene_path
