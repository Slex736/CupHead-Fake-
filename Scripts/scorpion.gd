extends Area2D

var direction: int = 1
var SPEED: int = 40

var JumpT: float = 0
# duration in seconds
var JumpDuration: float = 0.5

enum ScorpionStates {
	Idle,
	Jumping,
	JumpRecharge
}

var ScorpionState = ScorpionStates.Idle
var InJumpRange:bool = false

@onready var down: RayCast2D = $Raycasts/Down
@onready var right: RayCast2D = $Raycasts/Right
@onready var left: RayCast2D = $Raycasts/Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"


var ScorpionPos: Vector2
var PlayerPos: Vector2

var GravityAmount = 100


func _ready() -> void:
	animated_sprite_2d.flip_h = true


func _process(delta: float) -> void:
	if ScorpionState == ScorpionStates.Idle or ScorpionState == ScorpionStates.JumpRecharge:
		global_position.x = global_position.x + (SPEED * delta * direction)
	
	if InJumpRange == true:
		if player.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1
	
	elif ScorpionState == ScorpionStates.Jumping:
		if JumpT == 0:
			ScorpionPos = global_position
			PlayerPos = player.global_position
		var JumpX = (ScorpionPos.x + PlayerPos.x) / 2
		var JumpY = PlayerPos.y - 100
		var JumpPeak = Vector2(JumpX, JumpY) 
		
		JumpT += delta / JumpDuration
		JumpT = clamp(JumpT, 0.0, 1.01)
		
		global_position = _quadratic_bezier(ScorpionPos, JumpPeak, PlayerPos, JumpT)
		
		
		if JumpT >= 1.0:
			JumpT = 0.0
			ScorpionState = ScorpionStates.JumpRecharge
			var jump_recharge = Timer.new()
			jump_recharge.wait_time = 1
			jump_recharge.one_shot = true
			add_child(jump_recharge)

			jump_recharge.timeout.connect(_on_jump_recharge_timeout)
			jump_recharge.start()
			
			animated_sprite_2d.play("walking")

	CheckRaycasts()
	
	AddGravity(delta)

func CheckRaycasts():
	if left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	elif right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false
		
func PlayerEnteredHitBox(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()


func PlayerEnteredJumpBox(body: Node2D) -> void:
	if body is CharacterBody2D and ScorpionState == ScorpionStates.Idle:
		if player.global_position.x < global_position.x:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Jumping")
		InJumpRange = true


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

# sprite animation finished --> start physics
func OnJumpFinished() -> void:
	if ScorpionState == ScorpionStates.Idle:
		ScorpionState = ScorpionStates.Jumping
		

func AddGravity(delta):
	if not down.is_colliding() and ScorpionState != ScorpionStates.Jumping:
		global_position.y += GravityAmount * delta

func _on_jump_recharge_timeout() -> void:
	#  look if player still in jump radius after jump recharge
	if InJumpRange == false:
		ScorpionState = ScorpionStates.Idle
	else:
		ScorpionState = ScorpionStates.Idle
		animated_sprite_2d.play("Jumping")


func PlayerExitedJumpBox(body: Node2D) -> void:
	if body is CharacterBody2D:
		InJumpRange = false
