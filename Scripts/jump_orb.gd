extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var jump_orb: Area2D = $"."
@onready var TimerJumpOrb: Timer = $Timer

var OrbUsable: bool = false


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@export var JUMP_VELOCITY: int = -400
@export var Direction: String = "up"
@onready var player: CharacterBody2D = $"../../../Player"

func _process(_delta: float) -> void:
	if OrbUsable and Input.is_action_just_pressed("Jump"):
		if Direction == "up":
			player.velocity.y = JUMP_VELOCITY
		elif Direction == "down":
			player.velocity.y = -JUMP_VELOCITY
		elif Direction == "right":
			player.velocity.x = -JUMP_VELOCITY
		elif Direction == "left":
			player.velocity.x = JUMP_VELOCITY
		animations.play("Pressed")
		animations.animation_finished.connect(IsPressed)

func IsPressed():
	collision_shape_2d.disabled = true
	jump_orb.visible = false
	TimerJumpOrb.start()


func PlayerEntered(body: Node2D) -> void:
	OrbUsable = true


func PlayerExited(body: Node2D) -> void:
	OrbUsable = false


func TimerDone() -> void:
	collision_shape_2d.disabled = false
	jump_orb.visible = true
	animations.play("default")
