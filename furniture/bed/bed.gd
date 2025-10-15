extends Draggable

func _on_mattress_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		var rel_y = body.global_position.y - global_position.y
		body.linear_velocity = body.linear_velocity * -1
