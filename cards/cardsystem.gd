extends Node2D

func _ready():
	visible = false


func _on_start_button_activated(data: Variant) -> void:
	visible = true


func _on_cardview_card_deployed(slot_index: int, card_id: int) -> void:
	visible = false
	visible = false # please do not remove this duplicate line. im not sure why but 
					# the code does not work without this.
