extends Area2D

var direction: int = 1
var SPEED: int = 40

var JumpT: float = 0
# duration in seconds
var JumpDuration: float = 0.5

enum ScorpionStates {
	Idle,
	Jumping
}

var ScorpionState = ScorpionStates.Idle

@onready var right: RayCast2D = $Raycasts/Right
@onready var left: RayCast2D = $Raycasts/Left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"

var ScorpionPos: Vector2
var PlayerPos: Vector2

func _process(delta: float) -> void:
	if ScorpionState == ScorpionStates.Idle:
		global_position.x = global_position.x + (SPEED * delta * direction)

	elif ScorpionState == ScorpionStates.Jumping:
		if JumpT == 0:
			ScorpionPos = global_position
			PlayerPos = player.global_position
		var JumpX = (ScorpionPos.x + PlayerPos.x) / 2
		var JumpY = PlayerPos.y - 100
		var JumpPeak = Vector2(JumpX, JumpY) 
		JumpT += delta / JumpDuration
		JumpT = clamp(JumpT, 0.0, 1.0)
		global_position = _quadratic_bezier(ScorpionPos, JumpPeak, PlayerPos, JumpT)
		if JumpT == 1:
			JumpT = 0
			ScorpionState = ScorpionStates.Idle
	
	CheckRaycasts()

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
	if body is CharacterBody2D:
		animated_sprite_2d.play("Jumping")


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r


func OnJumpFinished() -> void:
	ScorpionState = ScorpionStates.Jumping
