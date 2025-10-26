extends Node2D

var checking: bool = false
var left_side_empty: bool = false
var right_side_empty: bool = false

func show_message_victory(side_won: String):
	$label.visible = true
	$label.text = side_won + " wins! \n\n Returning to Title Screen... (nilay todo)"
	checking = false

func _physics_process(delta: float) -> void:
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
