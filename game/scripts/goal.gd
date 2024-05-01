extends Area2D

@onready var transition = $"../transition"
@export var next_level : String = ''
@onready var sprite = $sprite

func _on_body_entered(body):
	if body.name == 'player' and next_level != '':
		sprite.play("butter_loop")


func _on_sprite_animation_finished():
	if sprite.animation == 'butter_loop':
		transition.change_scene(next_level)
