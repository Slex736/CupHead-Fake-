extends Area2D

@export var PosA: Vector2 
@export var PosB: Vector2

@export var FlySpeed: int = 100
@export var DiveSpeed: int = 200
@export var FlyBackUpSpeed: int = 50

var TargetPos: Vector2
var Direction: int
var DiveDirection: Vector2
var DivePos: Vector2
var FlyBackVector: Vector2
var FlyBackDirection: Vector2
var FlyBackAngle

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"


enum VultureStates {
	Fly,
	Dive,
	FlyBackUp
}

var VultureState = VultureStates.Fly

func _ready() -> void:
	global_position = PosA
	TargetPos = PosB

func _process(delta: float) -> void:
	if VultureState == VultureStates.Fly:
		if global_position.x < TargetPos.x:
			GoRight()
		else:
			GoLeft()
		
		global_position.x += Direction * FlySpeed * delta

	elif VultureState == VultureStates.Dive:
		var distance = global_position.distance_to(DivePos)

		if distance > 5:
			global_position += DiveSpeed * DiveDirection * delta
			animated_sprite_2d.play("Dive")
			animated_sprite_2d.rotation = FlyBackAngle
		else:
			VultureState = VultureStates.FlyBackUp
			CalcFlyBackUpRoute()
			CalcAngle(FlyBackDirection)
	
	elif VultureState == VultureStates.FlyBackUp:
		var distance = global_position.distance_to(FlyBackVector)
		
		if distance > 5:
			global_position += FlyBackUpSpeed * FlyBackDirection * delta
			animated_sprite_2d.play("default")
			animated_sprite_2d.rotation = FlyBackAngle
		else:
			VultureState = VultureStates.Fly
			ResetBird()

func GoLeft():
	Direction = -1
	TargetPos = PosB
	animated_sprite_2d.flip_h = false

func GoRight():
	Direction = 1
	TargetPos = PosA
	animated_sprite_2d.flip_h = true

func PlayerInHitbox(body: Node2D):
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()

func PlayerInDiveRange(body: Node2D):
	if body is CharacterBody2D:
		VultureState = VultureStates.Dive
		DivePos = player.global_position
		DiveDirection = (DivePos - global_position).normalized()
		CalcAngle(DiveDirection)

func CalcFlyBackUpRoute():
	var Length = PosA.y - global_position.y
	FlyBackVector = global_position + Vector2(Length, Length)
	FlyBackDirection = (FlyBackVector - global_position).normalized()
	if DiveDirection.x >= 0:
		InverseDirectionX()

func CalcAngle(InputAngle):
	if InputAngle.x < 0:
		FlyBackAngle = InputAngle.angle() + PI
		animated_sprite_2d.flip_v = false

	else:
		FlyBackAngle = InputAngle.angle() 
		animated_sprite_2d.flip_v = false




func InverseDirectionX():
	FlyBackDirection = Vector2(-FlyBackDirection.x, FlyBackDirection.y)

func ResetBird():
	animated_sprite_2d.flip_v = false
	animated_sprite_2d.rotation = 0.0
