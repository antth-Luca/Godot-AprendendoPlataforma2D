extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping := false
var is_hurted := false
var knockback_vector := Vector2.ZERO
var direction

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_right := $ray_right as RayCast2D
@onready var ray_left := $ray_left as RayCast2D
@onready var jump_sfx = $jump_sfx
@onready var break_sfx = preload("res://sounds/break_sfx.tscn")
@onready var hurt_sfx = $hurt_sfx

signal player_has_died()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	_set_state()
	move_and_slide()


func _on_hurtbox_body_entered(_body):
	hurt_sfx.play()
	if ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_left.is_colliding():
		take_damage(Vector2(200, -200))


func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal('player_has_died')
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0.286, 0.314)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
		
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false


func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"

	if is_hurted:
		state = "hurt"

	if animation.name != state:
		animation.play(state)


func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path


func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints <= 0:
			body.break_sprite()
			play_break_sfx()
		else:
			body.animation_player.play('hit')
			body.hit_sfx.play(0.1)
			body.create_coin()


func play_break_sfx():
	var sound = break_sfx.instantiate()
	get_parent().add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()
