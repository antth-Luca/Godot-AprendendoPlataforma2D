extends Area2D

var price_coin := 1
@onready var collect_sfx = $collect_sfx

func _on_body_entered(_body):
	$anim.play("collect")
	collect_sfx.play()
	await $collision.call_deferred('queue_free')
	Globals.coins += 1


func _on_anim_animation_finished():
	if $anim.animation == 'collect':
		queue_free()
