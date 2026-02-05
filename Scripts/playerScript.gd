extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


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
		
		

	# get input derection left = -1 and right = 1
	var direction := Input.get_axis("Left", "Right")
	if direction == 1:
		velocity.x = direction * SPEED
		
		animated_sprite.flip_h = false
		
	elif direction == -1:
		velocity.x = direction * SPEED
		
		animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("Idle")
	
	if not direction == 0:
		animated_sprite.play("Walking") 

	move_and_slide()
