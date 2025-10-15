extends GUIButton

signal skipturn


func _on_button_activated(data: Variant) -> void:
	skipturn.emit()
