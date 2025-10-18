extends Node2D

# Signals to card system to disable or enable
signal shooting_started
signal shooting_completed

# Reference to the shooting system
@onready var shooting_system: Node2D = get_node("../shootingsystem")

# Character data with their positions
var characters_data = {
	0: {"name": "char1", "position": Vector2(180, 92)},
	1: {"name": "char2", "position": Vector2(54, 144)}, 
	2: {"name": "char3", "position": Vector2(268, 223)}
}

var selected_character_id: int = -1
var characters_selectable: bool = false

# Signals
signal character_selected(character_id: int, position: Vector2)

func _ready():
	# Connect all character button signals
	connect_character_signals()
	# Initially make characters non-selectable
	set_characters_selectable(false)

func connect_character_signals():
	"""Connect all character button pressed signals"""
	for i in range(3):
		var char_node = get_node("char" + str(i + 1))
		if char_node and not char_node.pressed.is_connected(_on_character_pressed):
			char_node.pressed.connect(_on_character_pressed.bind(i))

func _on_character_pressed(character_id: int):
	"""Called when a character button is pressed"""
	if not characters_selectable:
		print("Characters are not selectable right now")
		return
	
	print("Character ", character_id + 1, " selected")
	selected_character_id = character_id
	
	# Get character position
	var char_position = characters_data[character_id]["position"]
	
	# Highlight selected character and dim others
	highlight_selected_character(character_id)
	
	# Emit signal and activate shooting system
	character_selected.emit(character_id, char_position)
	
	# Tell shooting system to show with this character's position
	if shooting_system:
		shooting_system.show_shooting_system_at_position(char_position)

func highlight_selected_character(selected_id: int):
	"""Highlight the selected character and dim the others"""
	for i in range(3):
		var char_node = get_node("char" + str(i + 1))
		if char_node:
			if i == selected_id:
				# Highlight selected character (full opacity, slight scale)
				
				char_node.modulate = Color(1.2, 1.2, 1.0, 1.0)  # Slightly yellow tint
			else:
				# Dim non-selected characters
				char_node.modulate = Color(0.5, 0.5, 0.5, 0.7)

func reset_character_appearance():
	"""Reset all characters to normal appearance"""
	for i in range(3):
		var char_node = get_node("char" + str(i + 1))
		if char_node:
			char_node.modulate = Color(1.0, 1.0, 1.0, 1.0)

func set_characters_selectable(selectable: bool):
	"""Enable or disable character selection"""
	characters_selectable = selectable
	
	if selectable:
		# Make characters more prominent when selectable
		for i in range(3):
			var char_node = get_node("char" + str(i + 1))
			if char_node:
				char_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
				# Optional: Add a subtle glow or border effect
	else:
		# Reset appearance when not selectable
		reset_character_appearance()
		selected_character_id = -1

func _on_card_deployed(slot_index: int, card_id: int):
	"""Called when a card is deployed/used - enable character selection"""
	if card_id != -1:  # -1 means skip turn, so don't make characters selectable
		print("Card deployed, enabling character selection")
		set_characters_selectable(true)
		shooting_started.emit()
	else:
		print("Turn skipped, disabling character selection")
		set_characters_selectable(false)

func _on_shooting_completed():
	"""Called when shooting is completed - disable character selection"""
	print("Shooting completed, disabling character selection")
	set_characters_selectable(false)
	reset_character_appearance()
	shooting_completed.emit()
