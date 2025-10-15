# This is the BASE class which basically defines the carddata struct.

extends Resource
class_name CardData

@export var id: int
@export var name: String
@export var icon: Texture2D
@export var description: String
@export var cooldown_turns: int
@export var effect_type: String
