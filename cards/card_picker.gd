extends Node
class_name CardPicker

signal card_pool_generated(cards: Array[CardData])
signal card_picked(card_data: CardData, player: int, index: int)
signal turn_changed(player: int)
signal picking_complete(player_1_deck: Array[CardData], player_2_deck: Array[CardData])

@export var cards_to_show: int = 10

var card_db: CardDB
var available_cards: Array = []
var player_1_deck: Array[CardData] = []
var player_2_deck: Array[CardData] = []
var current_player: int = 1
var remaining_picks: int = 0

func _ready() -> void:
	card_db = load("res://cards/card_db.gd").new()
	if card_db == null:
		push_error("CardPicker: Could not find CardDB node.")
		return
	else:
		print("CardPicker: card_db loaded")

	
