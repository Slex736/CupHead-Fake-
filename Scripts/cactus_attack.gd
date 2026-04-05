extends Area2D

var RaiseSpeed := 20
@export var MaxHeight: float

var StartPosY: float
var GoingUp := true

var Waiting: bool = false

func _ready() -> void:
	StartPosY = global_position.y


func _process(delta: float) -> void:
	if GoingUp and not Waiting:
		global_position.y -= RaiseSpeed * delta
		
		if global_position.y <= MaxHeight:
			Waiting = true
			await get_tree().create_timer(3.0).timeout
			GoingUp = false
			Waiting = false

	elif not GoingUp:
		global_position.y += RaiseSpeed * delta
		
		if global_position.y >= StartPosY:
			queue_free()



func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
