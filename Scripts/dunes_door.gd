extends Area2D


@onready var label: Label = $Label

enum States {Idle, PlayerInRange, Opened}

var DoorState: States = States.Idle

@export var current_level: int
@export var current_world: int = 1

func _process(_delta: float) -> void:
	if DoorState == States.Idle:
		MakeLabelInvisible()
	elif DoorState == States.PlayerInRange:
		MakeLabelVisible()
	if DoorState == States.PlayerInRange and Input.is_action_just_pressed("Interact"):
		LevelComplete()



func MakeLabelVisible():
	label.visible = true

func MakeLabelInvisible():
	label.visible = false

func LevelComplete():
	GameState.mark_level_completed(current_world, current_level)
	if current_level == 5:
		GameState.WorldUnlocked[2] = true
		GameState.BossLevelDunesUnlocked = true
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/dunes_levels_ui.tscn")

func PlayerEnteredRange(body: Node2D) -> void:
	if body is CharacterBody2D:
		DoorState = States.PlayerInRange


func PlayerLeavingRange(body: Node2D) -> void:
	if body is CharacterBody2D:
		DoorState = States.Idle
