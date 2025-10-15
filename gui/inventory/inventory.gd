extends Sprite2D

var original_pos: Vector2
var screen_size: Vector2
var sprite_size: Vector2

# if the cardviewer is currently focused/on screen
var active: bool

func _ready() -> void:
	original_pos = position
	screen_size = get_viewport().get_visible_rect().size
	sprite_size = texture.get_size()
	active = false


func _process(delta: float) -> void:
	
	# card view window move
	var speed = 8
	if active:
		position = position.lerp((screen_size)/Vector2(5, 3), delta*speed)
	else:
		position = position.lerp(original_pos, delta*speed)


func _on_invetorybutton_button_activated(data: Variant) -> void:
	active = true


func _on_cancel_button_activated(data: Variant) -> void:
	active = false


func _on_furnitureslot_0_furniture_picked() -> void:
	active = false 


func _on_start_button_activated(data: Variant) -> void:
	
	for child in get_parent().get_children():
		if not child is Draggable:
			child.visible = false
