extends RigidBody2D

class_name Firecracker

# Visual components
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Trajectory variables
var initial_velocity: Vector2
var launch_angle: float
var launch_power: float

# Card data
var card_data: CardData

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

func _process(_delta):
	"""Update firecracker during flight"""
	# Add rotation based on velocity for visual effect
	if linear_velocity.length() > 10:
		rotation = linear_velocity.angle()
