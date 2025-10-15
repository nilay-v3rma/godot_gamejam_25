extends GUIButton

signal card_used(card_id)

@export var card_id: int = 0

func _on_button_activated(data: Variant) -> void:
	card_used.emit(card_id)
