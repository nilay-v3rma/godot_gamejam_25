extends Node2D

var checking: bool = false
var right_side_empty: bool = false
var turns_taken: int = 0
var transition_counter: int = 5*60

func show_message_victory():
	$label.visible = true
	$label.text = "You won in " + str(turns_taken) + " turns!\n\n Returning to Title Screen..."
	checking = false

func _physics_process(delta: float) -> void:
	if $label.visible:
		transition_counter -= 1
		if transition_counter < 0:
			get_tree().change_scene_to_file("res://rooms/level.tscn")
	
	if not checking:
		return
	
	right_side_empty = true
	for node in $rightside.get_overlapping_bodies():
		if node is Draggable:
			right_side_empty = false
	
	if right_side_empty:
		show_message_victory()

func _on_start_button_activated(data: Variant) -> void:
	checking = true


func _on_cardview_card_deployed(slot_index: int, card_id: int) -> void:
	checking = true
	turns_taken += 1
