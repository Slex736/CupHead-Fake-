extends Area2D




func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
