extends RigidBody2D
class_name Draggable
#
#var dragging: bool = false
#var drag_finger_id: int = -1
#var drag_offset: Vector2 = Vector2.ZERO
#
#func _ready():
	#input_pickable = true  # allows detecting taps directly on this body
#
#func start_dragging(finger_id: int, touch_pos: Vector2) -> void:
	#dragging = true
	#drag_finger_id = finger_id
	#freeze = true
	#freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	#drag_offset = to_local(touch_pos)
	#global_position = touch_pos - drag_offset
#
#func stop_dragging() -> void:
	#dragging = false
	#drag_finger_id = -1
	#freeze = false
	#freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
		#if event.pressed:
			## Check if this touch is on this body
			#var space_state = get_world_2d().direct_space_state
			#var query = PhysicsPointQueryParameters2D.new()
			#query.position = event.position
			#var hits = space_state.intersect_point(query)
			#for hit in hits:
				#if hit["collider"] == self:
					#start_dragging(event.index, event.position)
					#break
		#else:
			## Finger released
			#if event.index == drag_finger_id:
				#stop_dragging()
#
	#elif event is InputEventScreenDrag and dragging and event.index == drag_finger_id:
		#global_position = event.position - drag_offset
