extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		body.velocity.y = body.JUMP_FORCE / 2
		owner.anim.play("hurt")
