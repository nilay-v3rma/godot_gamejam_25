extends RigidBody2D

class_name Firecracker
# scene MUST be in the following struction:
# crackername - Firecracker
# |- sprite - Sprite2D
# |- collision - CollisionShape2D
# |- flare - Area2d                    // it is the shape of the area 
#    |- shape - CollisionShape2D       // in which if another firecracker enters
#    |- particles - CPUParticles2D     // while ignited, it gets ignited.
# |- ignition - Area2D
#    |- shape - CollisionShape2D
#    |- particles - CPUParticles2D

# Visual components
@onready var sprite: Sprite2D = $sprite
@onready var collision: CollisionShape2D = $collision

var base_fps: float = 60.0
@export var explosion_strength: float = 800.0
@export var explosion_radius: float = 100.0
@export_range(0.0,25.0, 0.1) var ignite_time: float = 4.0
@export_range(0.0, 25.0, 0.1) var flare_time: float = 0.5
var ignition_in_count: int
var flare_lasts_count: int 
var is_flaring: bool = false
var is_ignited: bool = false

signal finished_flaring
signal just_ignited
signal started_flaring

# Trajectory variables
var initial_velocity: Vector2
var launch_angle: float
var launch_power: float

# Card data
var card_data: CardData

func _ready() -> void:
	$flare.connect("area_entered", Callable(self, "_on_flare_area_entered"))

# this function will most likely not be used anymore because each firecracker
# has its own scene now
func setup_with_card_data(data: CardData):
	"""Configure the firecracker based on card data"""
	card_data = data
	
	if not card_data:
		print("Warning: No card data provided to firecracker")
		return
	
	print("Setting up firecracker with card: ", card_data.name)
	
	# Set the sprite texture to the card's icon
	if sprite and card_data.icon:
		sprite.texture = card_data.icon
		
	# Adjust properties based on card type
	match card_data.id:
		1: # Simple Cracker
			sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)  # Red, fully opaque
			sprite.scale = Vector2(0.3, 0.1)
			mass = 0.3
		2: # Fountain
			sprite.modulate = Color(1.0, 0.5, 0.0, 1.0)  # Orange, fully opaque
			sprite.scale = Vector2(0.4, 0.2)
			mass = 0.4
		3: # Sutli Bomb
			sprite.modulate = Color(1.0, 1.0, 0.0, 1.0)  # Yellow, fully opaque
			sprite.scale = Vector2(0.5, 0.3)
			mass = 0.6
		4: # Ignited Matchstick
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)  # White, fully opaque
			sprite.scale = Vector2(0.2, 0.05)
			mass = 0.1
		_:
			# Default firecracker
			sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)  # Red, fully opaque
			sprite.scale = Vector2(0.3, 0.1)
	# Setup physics - using default gravity scale
	pass

func launch(angle_degrees: float, power: float, start_position: Vector2):
	"""Launch the firecracker with given angle and power"""
	
	# set ignition time:
	ignition_in_count = ignite_time * base_fps
	flare_lasts_count = flare_time * base_fps
	
	# Set position
	global_position = start_position
	
	# Store launch parameters
	launch_angle = angle_degrees
	launch_power = power
	
	# Convert angle to radians and calculate initial velocity
	var angle_rad = deg_to_rad(angle_degrees)
	var velocity_magnitude = power * 10.0  # Scale factor for power
	
	initial_velocity = Vector2(
		cos(angle_rad) * velocity_magnitude,
		sin(angle_rad) * velocity_magnitude
	)
	
	# Apply the initial velocity - launches the firecracker
	linear_velocity = initial_velocity
	
	print("Firecracker launched! Angle: ", angle_degrees, "°, Power: ", power, ", Velocity: ", linear_velocity)

func start_flare():
	is_flaring = true
	started_flaring.emit()
	$ignition/particles.emitting = false
	$flare/particles.emitting = true

func ignite():
	is_ignited = true
	just_ignited.emit()
	$ignition/particles.emitting = true


func explode():
	var space_state = get_world_2d().direct_space_state
	
	var radius = 100.0  # explosion radius
	var strength = 800.0 # how powerful the explosion is
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = radius
	query.transform = Transform2D(0, global_position)
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var body = result.collider
		if body is RigidBody2D and body != self:
			var dir = (body.global_position - global_position).normalized()
			body.apply_impulse(dir * strength)
	
	
	queue_free()



func _physics_process(_delta):
	"""Update firecracker during flight"""
	# Add rotation based on velocity for visual effect
	if linear_velocity.length() > 10:
		rotation = linear_velocity.angle()
	
	if is_ignited and ignition_in_count:
		ignition_in_count -= 1
		if (ignition_in_count == 0):
			start_flare()
	
	if is_flaring and flare_lasts_count:
		flare_lasts_count -= 1
		if (flare_lasts_count == 0):
			# KILL YOURSELF
			finished_flaring.emit()
			explode()
			queue_free()

func _on_flare_area_entered(area):
	print()
	var firecracker = area.get_parent()  # ignition/shape -> ignition -> Firecracker
	if firecracker is Firecracker and not firecracker.is_ignited and area.name == "ignition" and self.is_flaring:
		firecracker.ignite()
