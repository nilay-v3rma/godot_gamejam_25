extends Node2D

@onready var rotation_scrollbar: HScrollBar = $HScrollBar
@onready var power_scrollbar: HScrollBar = $HScrollBar2
@onready var aim_line: Line2D = $Line2D
@onready var shoot_button: TouchScreenButton = $Shoot

# Reference to the card system to disable/enable it
@onready var card_system: Node2D = get_node("../cardsystem")
# Reference to the characters system
@onready var characters_system: Node2D = get_node("../characters")

var base_position: Vector2 = Vector2(400, 300)
var line_length: float = 100.0

# Variables to remember previous settings
var previous_rotation: float = 0.0
var previous_power: float = 50.0

func _ready():
	# Hide the shooting system by default
	visible = false
	
	# Connect scrollbar signals only if not already connected
	if not rotation_scrollbar.value_changed.is_connected(_on_rotation_changed):
		rotation_scrollbar.value_changed.connect(_on_rotation_changed)
	if not power_scrollbar.value_changed.is_connected(_on_power_changed):
		power_scrollbar.value_changed.connect(_on_power_changed)
	
	# Connect shoot button signal
	if not shoot_button.pressed.is_connected(_on_shoot_button_pressed):
		shoot_button.pressed.connect(_on_shoot_button_pressed)
	
	# Set initial values
	rotation_scrollbar.value = previous_rotation
	power_scrollbar.value = previous_power
	
	# Update the line initially
	update_aim_line()

func _on_rotation_changed(value: float):
	"""Called when the rotation scrollbar value changes"""
	update_aim_line()

func _on_power_changed(value: float):
	"""Called when the power scrollbar value changes"""
	update_aim_line()

func update_aim_line():
	"""Update the Line2D based on current scrollbar values"""
	var rotation_degrees = rotation_scrollbar.value
	var power_percentage = power_scrollbar.value / power_scrollbar.max_value
	
	# Convert degrees to radians
	var rotation_radians = deg_to_rad(rotation_degrees)
	
	# Calculate the end position based on rotation and power
	var current_length = line_length * power_percentage #need a scaling factor here, to get appropriate end point
	var end_position = base_position + Vector2(
		cos(rotation_radians) * current_length,
		sin(rotation_radians) * current_length
	)
	
	# Update the Line2D points
	aim_line.points = PackedVector2Array([base_position, end_position])
	
	# Change color based on power
	var color_intensity = power_percentage
	aim_line.default_color = Color(1.0, 1.0 - color_intensity, 1.0 - color_intensity, 1.0)

func get_shooting_data():
	"""Returns the current shooting parameters"""
	return {
		"angle": rotation_scrollbar.value,
		"power": power_scrollbar.value,
		"direction": Vector2(
			cos(deg_to_rad(rotation_scrollbar.value)),
			sin(deg_to_rad(rotation_scrollbar.value))
		)
	}

func shoot():
	"""Call this function to execute a shot with current parameters"""
	var data = get_shooting_data()
	print("Shooting with angle: ", data.angle, " and power: ", data.power)
	
	# Save current settings for next time
	previous_rotation = rotation_scrollbar.value
	previous_power = power_scrollbar.value
	
	# Hide the shooting system after shooting
	hide_shooting_system()
	
	# shooting logic here

func _on_shoot_button_pressed():
	"""Called when the shoot button is pressed"""
	shoot()

func show_shooting_system():
	"""Show the shooting system when a card is used"""
	visible = true
	# Use previous settings from last turn
	rotation_scrollbar.value = previous_rotation
	power_scrollbar.value = previous_power
	update_aim_line()
	# Disable card system while shooting is active
	disable_card_system()

func show_shooting_system_at_position(character_position: Vector2):
	"""Show the shooting system at a specific character's position"""
	# Update the base position to the character's position
	base_position = character_position
	
	# Show the shooting system
	visible = true
	# Use previous settings from last turn
	rotation_scrollbar.value = previous_rotation
	power_scrollbar.value = previous_power
	update_aim_line()
	# Disable card system while shooting is active
	disable_card_system()
	
	print("Shooting system activated at position: ", character_position)

func hide_shooting_system():
	"""Hide the shooting system"""
	visible = false
	# Re-enable card system when shooting is complete
	enable_card_system()
	# Notify characters system that shooting is completed
	if characters_system:
		characters_system._on_shooting_completed()

func disable_card_system():
	"""Disable the card system while shooting is active"""
	if card_system:
		# Dim the card system and give it a greyish tint to show it's disabled
		card_system.modulate = Color(0.6, 0.6, 0.6, 0.8)
		
		# Disable all card slots
		for child in card_system.get_children():
			if child is CardSlot:
				child._disable_card_slot()
		print("Card system disabled")

func enable_card_system():
	"""Re-enable the card system after shooting is complete"""
	if card_system:
		# Restore full opacity and enable interactions
		card_system.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		# Re-enable all card slots
		for child in card_system.get_children():
			if child is CardSlot:
				child._enable_card_slot()
		print("Card system enabled")

func _on_card_deployed(slot_index: int, card_id: int):
	"""Called when a card is deployed/used"""
	# We no longer show shooting system directly here
	# Character selection will handle showing the shooting system
	print("Card deployed, waiting for character selection...")
