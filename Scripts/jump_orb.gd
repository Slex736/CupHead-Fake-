extends Area2D

var OrbUsable: bool = false

@onready var player: CharacterBody2D = $"../../../Player"
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
var JUMP_VELOCITY: int = -400

func _process(_delta: float) -> void:
	if OrbUsable and Input.is_action_just_pressed("Jump"):
		player.velocity.y = JUMP_VELOCITY
		animations.play("Pressed")
		animations.animation_finished.connect(IsPressed)

func IsPressed():
	queue_free()


func PlayerEntered(body: Node2D) -> void:
	OrbUsable = true


func PlayerExited(body: Node2D) -> void:
	OrbUsable = false
