extends Area2D


func PlayerInDeathZone(body: Node2D) -> void:
	if body is CharacterBody2D:
		InGameUI()


func InGameUI():
	get_tree().change_scene_to_file("res://Scenes/UI/ingame_settings.tscn")
