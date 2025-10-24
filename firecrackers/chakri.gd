extends Firecracker

@export_range(200.0, 2000.0, 10.0) var spin_speed: float = 1000

func _physics_process(delta):
	super(delta)
	if is_flaring:
		# Apply constant spin
		angular_velocity = deg_to_rad(spin_speed)  # Godot uses radians/sec
	else:
		angular_velocity = 0
