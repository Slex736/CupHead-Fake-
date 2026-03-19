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
			animated_sprite_2d.rotation = DiveDirection.angle() + deg_to_rad(180)
			animated_sprite_2d.play("Dive")
		else:
			VultureState = VultureStates.FlyBackUp
			CalcFlyBackUpRoute()
	
	elif VultureState == VultureStates.FlyBackUp:
		var distance = global_position.distance_to(FlyBackVector)
		
		if distance > 5:
			global_position += FlyBackUpSpeed * FlyBackDirection * delta
			if FlyBackDirection.x <= 0:
				animated_sprite_2d.rotation = FlyBackDirection.angle() + deg_to_rad(180)
			else:
				animated_sprite_2d.rotation = FlyBackDirection.angle() 
				# animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("default")
		else:
			pass

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

func CalcFlyBackUpRoute():
	var Length = PosA.y - global_position.y
	FlyBackVector = global_position + Vector2(Length, Length)
	FlyBackDirection = (FlyBackVector - global_position).normalized()
	if DiveDirection.x >= 0:
		FlyBackDirection = Vector2(-FlyBackDirection.x, FlyBackDirection.y)
