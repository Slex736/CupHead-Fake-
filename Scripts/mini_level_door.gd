extends Area2D


@onready var label: Label = $Label

enum States {Idle, PlayerInRange, Opened}

var DoorState: States = States.Idle




func _ready() -> void:
	label.text = "Press E to enter"

func _process(_delta: float) -> void:
	if DoorState == States.Idle:
		MakeLabelInvisible()
	elif DoorState == States.PlayerInRange:
		MakeLabelVisible()
	if DoorState == States.PlayerInRange and Input.is_action_just_pressed("Interact"):
		LoadMiniLevel()



func MakeLabelVisible():
	label.visible = true

func MakeLabelInvisible():
	label.visible = false

func LoadMiniLevel():
	LevelManager.load_ui()

func PlayerEnteredRange(body: Node2D) -> void:
	if body is CharacterBody2D:
		DoorState = States.PlayerInRange


func PlayerLeavingRange(body: Node2D) -> void:
	if body is CharacterBody2D:
		DoorState = States.Idle
