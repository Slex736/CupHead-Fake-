extends Area2D

enum FlagStates {
	Idle,
	# process of activating
	# |
	Activation,
	# has been activated and can be used
	# |
	Active
}

var FlagState = FlagStates.Idle



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if GameState.LatestCheckPointPos != null:
		FlagState = FlagStates.Active
		animated_sprite_2d.play("Active")

func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D and FlagState == FlagStates.Idle:
		animated_sprite_2d.play("Activated")
		FlagState = FlagStates.Activation
		GameState.LatestCheckPointPos = global_position


func ActivationFinished() -> void:
	FlagState = FlagStates.Active
	animated_sprite_2d.play("Active")
