extends RigidBody2D

var dragging := false
var drag_offset := Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = event.position
			var result = space_state.intersect_point(query)
			for hit in result:
				if hit["collider"] == self:
					dragging = true
					drag_offset = to_local(event.position)
					set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
					freeze = true
					break
		else:
			if dragging:
				dragging = false
				freeze = false
				set_freeze_mode(RigidBody2D.FREEZE_MODE_STATIC)
				# optional: fling a little
				apply_central_impulse(linear_velocity * 0.5)

	elif event is InputEventMouseMotion or event is InputEventScreenDrag:
		if dragging:
			global_position = event.position - drag_offset
