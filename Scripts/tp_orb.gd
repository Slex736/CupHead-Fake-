extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var jump_orb: Area2D = $"."
@onready var TimerJumpOrb: Timer = $Timer

var OrbUsable: bool = false


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../../Player"

@export var Destination: Vector2 = Vector2(0, 0)
@export var Height: int = -100
@export var Duration: float = 1

var JumpPeak: Vector2
var JumpT: float = 0

var StartPos: Vector2

enum OrbStates{
	Idle,
	Launching
}

var OrbState = OrbStates.Idle

func _ready() -> void:
	animations.animation_finished.connect(IsPressed)

func _process(delta: float) -> void:
	if OrbUsable and Input.is_action_just_pressed("Jump"):
		JumpT = 0.0
		animations.play("Pressed")
		OrbState = OrbStates.Launching
	
	if OrbState == OrbStates.Launching:
		#determine startPos and jumpeak at the start
		if JumpT == 0:
			StartPos = player.global_position
			JumpPeak = CalcJumpPeak()
			player.set_physics_process(false)
		
		JumpT = CalcJumpT(delta)
			
		player.global_position = GameState._quadratic_bezier(StartPos, JumpPeak, Destination, JumpT)

func IsPressed():
	collision_shape_2d.disabled = true
	jump_orb.visible = false
	TimerJumpOrb.start()


func PlayerEntered(_body: Node2D) -> void:
	OrbUsable = true


func PlayerExited(_body: Node2D) -> void:
	OrbUsable = false


func TimerDone() -> void:
	collision_shape_2d.disabled = false
	jump_orb.visible = true
	animations.play("default")

func CalcJumpPeak():
	var JumpPeakX = (global_position.x + Destination.x) / 2
	var jumpPeakY = ((global_position.y + Destination.y) / 2) + Height
	return Vector2(JumpPeakX, jumpPeakY) 

func CalcJumpT(delta):
	JumpT += delta * Duration
	JumpT = clamp(JumpT, 0.0, 1.0)
	if JumpT >= 1.0:
		OrbState = OrbStates.Idle
		player.set_physics_process(true)
	return JumpT
