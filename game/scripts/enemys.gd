extends CharacterBody2D
class_name EnemyBase

const SPEED = 600.0
var direction := -1

@onready var anim := $anim
@export var enemy_score := 100

var wall_detector
var texture
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_position

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func movement(delta):
	velocity.x = direction * SPEED * delta

	move_and_slide()


func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false


func kill_abobora_enemy(_anim_name: StringName) -> void:
	kill_and_score()


func kill_chery_enemy() -> void:
	kill_and_score()


func kill_and_score():
	Globals.score += enemy_score
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()


func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position
