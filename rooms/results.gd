extends Node2D

var checking: bool = false
var left_side_empty: bool = false
var right_side_empty: bool = false
var transition_counter: int = 5*60

func show_message_victory(side_won: String):
	$label.visible = true
	$label.text = side_won + " wins! \n\n Returning to Title Screen..."
	checking = false

func _physics_process(delta: float) -> void:
	if $label.visible:
		transition_counter -= 1
		if transition_counter < 0:
			get_tree().change_scene_to_file("res://rooms/level.tscn")
	
	if not checking:
		return
	
	left_side_empty = true
	for node in $leftside.get_overlapping_bodies():
		if node is Student:
			left_side_empty = false
	right_side_empty = true
	for node in $rightside.get_overlapping_bodies():
		if node is Student:
			right_side_empty = false
	
	if left_side_empty:
		show_message_victory("Right")
	elif right_side_empty:
		show_message_victory("Left")

func _on_start_button_activated(data: Variant) -> void:
	checking = true
