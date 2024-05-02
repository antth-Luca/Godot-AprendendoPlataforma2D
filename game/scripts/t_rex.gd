extends CharacterBody2D

const FIREBALL = preload("res://prefabs/fireball.tscn")

var move_speed := 50
var direction = 1
var health_points := 3
@onready var sprite = $sprite
@onready var anim = $anim
@onready var fireball_spawn = $fireball_spawn
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()
		EnemyState.HURT : hurt_state()


func patrol_state():
	anim.play("running")
	
	if is_on_wall():
		flip_enemy()
		
	if !ground_detector.is_colliding():
		flip_enemy()

	velocity.x = move_speed * direction
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	
	move_and_slide()


func attack_state():
	anim.play("shooting")
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)


func hurt_state():
	anim.play('hurt')
	await get_tree().create_timer(0.3).timeout
	_change_state(EnemyState.PATROL)
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()


func _change_state(state):
	current_state = state


func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fireball_spawn.position.x *= -1


func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spawn.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spawn.global_position


func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
