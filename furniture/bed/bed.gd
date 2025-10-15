extends RigidBody2D

func _on_mattress_body_entered(body: Node2D) -> void:
	#if body is RigidBody2D:
		## Get vector from bed center to body
		#var rel_pos = body.global_position - global_position
		#
		## Approximate contact normal: perpendicular to bed top surface
		## If the bed sprite is rotated, its "up" is rotated
		#var normal = Vector2.UP.rotated(global_rotation)
		#
		## Only bounce if the body is moving toward the bed (dot product < 0)
		#if body.linear_velocity.dot(normal) > 0:
			#return  # body is moving away, no bounce
		#
		## Compute impulse to reverse velocity along the normal
		#var v_along_normal = body.linear_velocity.dot(normal)
		#var impulse = -v_along_normal * body.mass * normal  # equal and opposite
		#body.apply_impulse(impulse)
	if body is RigidBody2D:
		var rel_y = body.global_position.y - global_position.y
		body.linear_velocity = body.linear_velocity * -1
		#if rel_y < -5:
			## Apply an upward impulse
			#var impulse_strength = body.mass * 600
			#body.apply_impulse(Vector2(0, -impulse_strength))
