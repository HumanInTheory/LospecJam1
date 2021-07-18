extends RigidBody2D

func _on_ManaShot_body_entered(body):
	if body.name == "Player":
		return
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
