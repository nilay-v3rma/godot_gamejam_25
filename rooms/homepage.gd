extends Sprite2D

func _ready():
	# Connect to the start1 button's signal
	$start1.button_activated.connect(_on_start1_pressed)

func _on_start1_pressed(_data):
	# Create a tween for smooth animation
	var tween = create_tween()
	tween.set_parallel(true)  # Allow multiple animations to run simultaneously
	
	# Move the homepage node downward (increase y position by 1000 pixels)
	tween.tween_property(self, "position", position + Vector2(0, 1000), 1.0)
	
	# Fade out the homepage node (make it invisible)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0)
	
	# Optional: After animation completes, you can hide the node completely
	tween.tween_callback(func(): visible = false).set_delay(1.0)