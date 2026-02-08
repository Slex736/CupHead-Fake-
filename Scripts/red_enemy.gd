extends Area2D

@onready var leftraycast: RayCast2D = $Left
@onready var rightraycast: RayCast2D = $Right

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum Dir {Left, Right}

var direction: Dir = Dir.Left

const SPEED = 50

func _physics_process(delta: float) -> void:
	# movement script
	MoveEnemy(delta)
	# check raycast to see if the enemy needs to change direction.
	RayCastChecker()
	
	


func PlayerTouchedEnemy(body: Node2D) -> void:
	if body is CharacterBody2D:
		ResetLevel()

func ResetLevel():
	set_deferred("monitoring", false) # if this script is on an Area2D
	get_tree().call_deferred("reload_current_scene")

func MoveEnemy(delta):
	if direction == Dir.Left:
		position.x -= SPEED * delta
		animated_sprite_2d.flip_h = true
	elif direction == Dir.Right:
		position.x += SPEED * delta
		animated_sprite_2d.flip_h = false

func RayCastChecker():
	if leftraycast.is_colliding():
		direction = Dir.Right
	elif rightraycast.is_colliding():
		direction = Dir.Left
