extends EnemyBase

func _ready():
	anim.animation_finished.connect(kill_chery_enemy)

func _physics_process(delta):
	_apply_gravity(delta)
	movement(delta)
