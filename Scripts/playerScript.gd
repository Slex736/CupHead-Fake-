extends CharacterBody2D

<<<<<<< HEAD
@export var SPEED = 130
const JUMP_VELOCITY = -300.0
=======
const SPEED = 105
const JUMP_VELOCITY = -330.0
>>>>>>> dc6bf45636241917f3851a2fd00b8720c1855381

const NormalAcceleration = 500
const NormalFriction = 1000

const IceAccelaration = 100
const IceFriction = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

var platform_velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite.play("Jump")
	
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	# check if floortype is normal block and apply normal physics
	if GameState.FloorType == 0:
		Walk(SPEED, NormalFriction, NormalAcceleration, delta)
	
	elif GameState.FloorType == 1:
		Walk(SPEED, IceFriction, IceAccelaration, delta)
	



func Walk(Speed, Friction, Acceleration, Delta):
	# get input derection left = -1 and right = 1
	var direction := Input.get_axis("Left", "Right")
	if direction == 1:
		#velocity.x = direction * SPEED
		if GameState.FloorType == 1:
			velocity.x = move_toward(velocity.x, direction * Speed, Acceleration * Delta)
		elif GameState.FloorType == 0:
			velocity.x = direction * Speed
		# switch player back
		animated_sprite.flip_h = false
	elif direction == -1:
		if GameState.FloorType == 1:
			velocity.x = move_toward(velocity.x, direction * Speed, Acceleration * Delta)
		elif GameState.FloorType == 0:
			velocity.x = direction * Speed
		animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, Friction * Delta)
		animated_sprite.play("Idle")
			
	if not direction == 0:
		animated_sprite.play("Walking") 
		
	move_and_slide()
