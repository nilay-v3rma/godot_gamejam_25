extends GUIButton

signal card_used(card_id)

func _on_button_activated(data: Variant) -> void:
	card_used.emit(0)
