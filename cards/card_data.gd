# This is the BASE class which basically defines the carddata struct.

extends Resource
class_name CardData

@export var id: int
@export var name: String
@export var icon: Texture2D
@export var description: String
@export var cooldown_turns: int
@export var effect_type: String
@export var scene: String

# scene is a path to the projectile sccene of that particular Card's object.
# Each scene MUST be in the following struction:
# crackername - Firecracker
# |- sprite - Sprite2D
# |- collision - CollisionShape2D
# |- flare - Area2d                    // it is the shape of the area 
#    |- shape - CollisionShape2D       // in which if another firecracker enters
#                                      // while ignited, it gets ignited.
