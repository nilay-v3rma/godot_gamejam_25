extends Node
class_name CardDB

var cards: Dictionary = {}

func _ready() -> void:
	for i in range(1, 7):
		_register_card("res://cards/card data/card"+str(i)+".tres")

func _register_card(path: String):
	print("attemping to register: "+ path)
	var card: CardData = load(path)
	cards[card.id] = card
	print(card.id, card.name)

func get_card(id: int) -> CardData:
	print("Attempting to get card id:", str(id))
	return cards.get(id)

func get_random_card() -> CardData:
	var keys = cards.keys()
	var random_key = keys[randi() % keys.size()]
	return cards[random_key]
