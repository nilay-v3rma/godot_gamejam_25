extends GUIButton

func remove_drag(root: Node):
	for child in root.get_children():
		if child is Draggable:
			child.set_draggable(false)
		remove_drag(child)

func _on_button_activated(data: Variant) -> void:
	remove_drag(get_tree().current_scene)
	queue_free()
