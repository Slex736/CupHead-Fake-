extends CharacterBody2D

@export var GodMode: bool = false



const SPEED = 105
const JUMP_VELOCITY = -330.0

var DashSpeed = 220
var DashDirection := Vector2(0 , 0)  

const NormalAcceleration = 500
const NormalFriction = 1000

const IceAccelaration = 100
const IceFriction = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var cayotte_timer: Timer = $CayotteTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

var AttackCactusBossFightAnimation: AnimatedSprite2D 
var AttackCactusBossFightCollision: CollisionShape2D
var AttackCactusBossFightInstance

var CanAttackCactusBoss: bool

var platform_velocity := Vector2.ZERO

var CanJump: bool = false
var WasOnFloor: bool = true

enum PLayerStates {
	Walking,
	Dashing
}

var PLayerState = PLayerStates.Walking

func _ready() -> void:
	if GameState.LatestCheckPointPos != null:
		global_position = GameState.LatestCheckPointPos
	GameState.CanDash = true
	
	
	# look if its the bossfight
	if GameState.current_level == "res://Scenes/Levels/BossFights/boss_fight_desert.tscn":
		var AttackCactusBossFightScene = preload("res://Scenes/Player/Attacks/attack_cactus_boss_fight.tscn")
		AttackCactusBossFightInstance = AttackCactusBossFightScene.instantiate()
		add_child(AttackCactusBossFightInstance)
		
		AttackCactusBossFightAnimation = $AttackCactusBossFight/AnimatedSprite2D
		AttackCactusBossFightCollision = $AttackCactusBossFight/CollisionShape2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and PLayerState != PLayerStates.Dashing:
		velocity += get_gravity() * delta
		animated_sprite.play("Jump")
		if WasOnFloor:
			cayotte_timer.start()
		WasOnFloor = false
	
	if is_on_floor():
		CanJump = true
		WasOnFloor = true
	
	if CanJump == false and Input.is_action_just_pressed("Dash") and GameState.CanDash:
		PLayerState = PLayerStates.Dashing
		Dash()
		
	if CanJump:
		# Handle jump.
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			CanJump = false

	if PLayerState != PLayerStates.Dashing:
		# check if floortype is normal block and apply normal physics
		if GameState.FloorType == 0:
			Walk(SPEED, NormalFriction, NormalAcceleration, delta)
		
		elif GameState.FloorType == 1:
			Walk(SPEED, IceFriction, IceAccelaration, delta)

	move_and_slide()
	
	
	
	if GameState.current_level == "res://Scenes/Levels/BossFights/boss_fight_desert.tscn" and Input.is_action_just_pressed("Attack"):
		HandleAttack()


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
		



func _on_cayotte_timer_timeout() -> void:
	CanJump = false

func Dash():
	DashDirection = Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Jump", "Down")
	).normalized()
	
	animated_sprite.play("Dash")
	

	velocity = DashDirection * DashSpeed
	
	collision_shape_2d.position.y = 3.0
	collision_shape_2d.scale.y = 0.5
	
	if GodMode == false:
		dash_cooldown_timer.start()
		GameState.CanDash = false
	

func DashAnimationFinished():
	if animated_sprite.animation == "Dash":
		PLayerState = PLayerStates.Walking
		collision_shape_2d.position.y = 1.5
		collision_shape_2d.scale.y = 1.0


func DashCooldownTimeout() -> void:
	GameState.CanDash = true

func HandleAttack():
	if CanAttackCactusBoss:
		AttackCactusBossFightInstance.visible = true
		AttackCactusBossFightCollision.disabled = false
		AttackCactusBossFightAnimation.play("Slash")
		await AttackCactusBossFightAnimation.animation_finished
		AttackCactusBossFightCollision.disabled = true
		AttackCactusBossFightInstance.visible = false
