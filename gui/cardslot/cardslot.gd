extends GUIButton
class_name CardSlot

const OPEN = preload("res://audio/open-card-sfx.wav")

@onready var sound = $"../../sounds"

signal card_used(card_id)

@export var slot_index: int = 0
@export var card_id: int
var card: CardData
var cooldown: int = 0
var disabled: bool = false


func _ready() -> void:
	super()
	card = CardDBInst.get_card(card_id)
	$cardicon.texture = card.icon

func new_card() -> void:
	card = CardDBInst.get_random_card()
	card_id = card.id
	$cardicon.texture = card.icon

func _process(delta: float) -> void:
	
	if (cooldown == 0):
		$cooldown.visible = false
	else:
		$cooldown.text = str(cooldown)
		$cooldown.visible = true

func _on_button_activated(data: Variant) -> void:
	sound.play_ui_sound(OPEN)
	card_used.emit(card_id)


func _on_cardview_card_deployed(slot_index: int, card_id: int) -> void:
	if slot_index == self.slot_index:
		cooldown = card.cooldown_turns
		$cardicon.texture = null
	elif cooldown > 0:
		cooldown -= 1
		if (cooldown == 0):
			new_card()

func _disable_card_slot():
	disabled = true
	print("called")
	# Try multiple approaches to hide the card icon
	# $cardicon.visible = false  # Hide the sprite completely
	
func _enable_card_slot():
	disabled = false
	# Restore visibility and transparency
	#$cardicon.visible = true
	if card:
		$cardicon.texture = card.icon
