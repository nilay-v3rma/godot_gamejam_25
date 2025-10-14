extends Sprite2D

var original_pos: Vector2
var screen_size: Vector2
var sprite_size: Vector2

# if the cardviewer is currently focused/on screen
var active: bool
var viewing_card_id: int

# main signal
signal card_deployed(card_id)

func _ready() -> void:
	original_pos = position
	screen_size = get_viewport().get_visible_rect().size
	sprite_size = texture.get_size()
	active = false

func _process(delta: float) -> void:
	
	# card view window move
	var speed = 8
	if active:
		position = position.lerp((screen_size)/2, delta*speed)
	else:
		position = position.lerp(original_pos, delta*speed)

func card_used(card_id):
	viewing_card_id = card_id
	active = true

func _on_cardslot_0_card_used(card_id: Variant) -> void:
	card_used(card_id)

func _on_use_button_activated(data: Variant) -> void:
	card_deployed.emit(viewing_card_id)
	active = false

func _on_dont_button_activated(data: Variant) -> void:
	active = false
