extends Area2D

var price_coin := 1

func _on_body_entered(_body):
	$anim.play("collect")
	await $collision.call_deferred('queue_free')
	Globals.coins += 1


func _on_anim_animation_finished():
	if $anim.animation == 'collect':
		queue_free()
