extends GUIButton

@export var furniture_id: int
@export var amount: int
var furniture: FurnitureData

signal furniture_picked


func update_label() -> void:
	$label.text = furniture.name + "\nAvailable: " + str(amount)
	if (amount == 0):
		visible = false


func _ready() -> void:
	super()
	furniture = FurnitureDBInst.get_furniture(furniture_id)
	update_label()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed \
	  and rect.has_point(to_local(event.position)):
		print(event)
		hide_inventory()
		spawn_furniture(event.index, event.position)

func hide_inventory() -> void:
	furniture_picked.emit()

func spawn_furniture(finger_id: int, position: Vector2) -> void:
	var path = FurnitureDBInst.get_scene_path(furniture_id)
	var furniture_scene = load(path)
	var furniture = furniture_scene.instantiate()
	furniture.global_position = position
	get_parent().get_parent().add_child(furniture) # to buildsystem
	furniture.start_dragging(finger_id, position)
	amount -= 1
	update_label()
