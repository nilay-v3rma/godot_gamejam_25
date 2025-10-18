extends Firecracker


var thrust_force: float = 1200.0
var wiggle_strength: float = 0.05

func _ready():
	gravity_scale = 0.2  # reduce gravity so the rocket can rise

func _physics_process(delta):
	super(delta)
	if is_flaring:  # <-- changed from 'running'
		# Apply thrust in the local up direction
		var thrust = Vector2.UP.rotated(rotation) * thrust_force * delta
		apply_central_impulse(thrust)
		# Slight random wiggle to mimic a real rocket
		rotation += randf_range(-wiggle_strength, wiggle_strength)
