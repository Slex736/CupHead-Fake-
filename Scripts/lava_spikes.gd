extends Area2D


func PlayerEnteredLavaSpikes(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
