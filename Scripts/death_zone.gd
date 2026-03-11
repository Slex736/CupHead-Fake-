extends Area2D


func PlayerInDeathZone(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()


func _on_scorpion_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
