extends Node
class_name CardDB

var cards: Dictionary = {}

func _ready() -> void:
	for i in range(1, 5):
		_register_card("res://cards/card data/card"+str(i)+".tres")

func _register_card(path: String):
	var card = load(path)
	cards[card.id] = card

func get_card(id: String) -> CardData:
	return cards.get(id)
