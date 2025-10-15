extends Sprite2D

var original_pos: Vector2
var screen_size: Vector2
var sprite_size: Vector2

# if the cardviewer is currently focused/on screen
var active: bool
var viewing_card_id: int
var viewing_card: CardData
var db: CardDB
var invoked_card_slot: int

# main signal # for card skip, -1 -1 is emitted
signal card_deployed(slot_index: int, card_id: int)

func _ready() -> void:
	original_pos = position
	screen_size = get_viewport().get_visible_rect().size
	sprite_size = texture.get_size()
	active = false
	
	# Load the card database to reference
	db = load("res://cards/card_db.gd").new()
	add_child(db)


func _process(delta: float) -> void:
	
	# card view window move
	var speed = 8
	if active:
		position = position.lerp((screen_size)/2, delta*speed)
	else:
		position = position.lerp(original_pos, delta*speed)

func card_used(card_id):
	viewing_card_id = card_id
	viewing_card = db.get_card(card_id)
	$name.text = viewing_card.name
	$type.text = viewing_card.effect_type
	$icon.texture = viewing_card.icon
	$description.text = viewing_card.description
	$cooldown.text = "Cooldown: " + str(viewing_card.cooldown_turns) + " turns"
	active = true

func _on_use_button_activated(data: Variant) -> void:
	card_deployed.emit(invoked_card_slot, viewing_card_id)
	active = false

func _on_dont_button_activated(data: Variant) -> void:
	active = false


func _on_cardslot_0_card_used(card_id: Variant) -> void:
	invoked_card_slot = 0
	card_used(card_id)
func _on_cardslot_1_card_used(card_id: Variant) -> void:
	invoked_card_slot = 1
	card_used(card_id)
func _on_cardslot_2_card_used(card_id: Variant) -> void:
	invoked_card_slot = 2
	card_used(card_id)
func _on_cardslot_3_card_used(card_id: Variant) -> void:
	invoked_card_slot = 3
	card_used(card_id)


func _on_skipturn_skipturn() -> void:
	card_deployed.emit(-1, -1)
