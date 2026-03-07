extends Area2D



func OnBodyEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
