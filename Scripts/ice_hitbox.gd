extends Area2D


func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.FloorType = 1


func PlayerExited(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.FloorType = 0
