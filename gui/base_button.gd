extends TouchScreenButton
class_name GUIButton

# for the scale animation
var sprite_size: Vector2
var original_scale: Vector2
var original_pos: Vector2
var squish_amount: float = 0.7
var rect: Rect2 # for bounds checking of the button
var pressable: bool = true

signal button_activated(data)

func _ready() -> void:
	# all of this infromation is useful for the squish animation or bound checks
	sprite_size = texture_normal.get_size()
	rect = Rect2(Vector2.ZERO, sprite_size)
	original_scale = self.scale
	original_pos = self.position
	print(original_scale, original_pos, "here")

func _physics_process(delta: float) -> void:
	
	# squish animation
	var speed = 10.0
	var target_offset = sprite_size * (1 - squish_amount) * 0.5

	if is_pressed():
		pass
		scale = scale.lerp(original_scale * squish_amount, speed * delta)
		position = position.lerp(original_pos+ target_offset, speed * delta)
	else:
		pass
		scale = scale.lerp(original_scale, speed * delta)
		position = position.lerp(original_pos, speed * delta)

# did not use the "_released" signal because it doesn't have the event parameter to check bounds
func _unhandled_input(event):
	if event is InputEventScreenTouch and not event.pressed:
		var local_pos = to_local(event.position)
		if rect.has_point(local_pos) and pressable:
			button_activated.emit(0)


func _on_characters_shooting_completed() -> void:
	pass # Replace with function body.
