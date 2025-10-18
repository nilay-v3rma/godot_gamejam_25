extends Sprite2D

# Scene references for the different stages
const RIGHTSTAGE1_SCENE = preload("res://rooms/rightstage1.tscn")
const RIGHTSTAGE2_SCENE = preload("res://rooms/rightstage2.tscn")
const RIGHTSTAGE3_SCENE = preload("res://rooms/rightstage3.tscn")

# References to the level buttons
@onready var level1_button = $level1
@onready var level2_button = $level2
@onready var level3_button = $level3

# Position constants
const GAMEPLAY_POSITION = Vector2(990, 491)  # Where the active stage should be

# Current active stage instance
var current_stage_instance = null

func _ready():
	# Connect the button signals to their respective handlers
	level1_button.button_activated.connect(_on_level1_selected)
	level2_button.button_activated.connect(_on_level2_selected)
	level3_button.button_activated.connect(_on_level3_selected)

func _clear_current_stage():
	"""Remove the currently active stage instance"""
	if current_stage_instance != null:
		current_stage_instance.queue_free()
		current_stage_instance = null

func _spawn_stage(stage_scene):
	"""Spawn a new stage instance at the gameplay position"""
	# Clear any existing stage
	_clear_current_stage()
	
	# Create new instance
	current_stage_instance = stage_scene.instantiate()
	current_stage_instance.position = GAMEPLAY_POSITION
	
	# Add to the main scene (parent of levelpage)
	get_parent().add_child(current_stage_instance)

func _on_level1_selected(data):
	"""Handle level 1 button press"""
	print("Level 1 selected")
	_spawn_stage(RIGHTSTAGE1_SCENE)
	# Hide the levelpage when a level is selected
	self.visible = false

func _on_level2_selected(data):
	"""Handle level 2 button press"""
	print("Level 2 selected")
	_spawn_stage(RIGHTSTAGE2_SCENE)
	# Hide the levelpage when a level is selected
	self.visible = false

func _on_level3_selected(data):
	"""Handle level 3 button press"""
	print("Level 3 selected")
	_spawn_stage(RIGHTSTAGE3_SCENE)
	# Hide the levelpage when a level is selected
	self.visible = false
