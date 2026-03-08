extends Area2D

# 1 = right, -1 = left
var direction = 1

@export var SPEED = 40

enum PolarBearStates {
	Agro,
	Passive
}

var PolarBearState = PolarBearStates.Passive

# import raycasts
@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var agro_hitbox: Area2D = $AgroHitbox


func _process(delta: float) -> void:
	if PolarBearState == PolarBearStates.Passive:
		global_position.x = global_position.x + (SPEED * delta * direction)

	elif PolarBearState == PolarBearStates.Agro:
		pass
	
	CheckRaycasts()

func CheckRaycasts():
	if left_raycast.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	elif right_raycast.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false


		 

func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()


func CheckAgroHitbox(body: Node2D) -> void:
	if body is CharacterBody2D:
		PolarBearState = PolarBearStates.Agro
