extends Area2D

@onready var leftraycast: RayCast2D = $Left
@onready var rightraycast: RayCast2D = $Right


enum Dir {Left, Right}

var direction: Dir = Dir.Left

const SPEED = 50

func _physics_process(delta: float) -> void:
	if direction == Dir.Left:
		position.x -= SPEED * delta
	elif direction == Dir.Right:
		position.x += SPEED * delta
	
	if leftraycast.is_colliding():
		direction = Dir.Right
	elif rightraycast.is_colliding():
		direction = Dir.Left
	

func PlayerTouchedEnemy(body: Node2D) -> void:
	if body is CharacterBody2D:
		set_deferred("monitoring", false) # if this script is on an Area2D
		get_tree().call_deferred("reload_current_scene")
