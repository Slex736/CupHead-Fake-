extends Area2D


func PlayerInDeathZone(body: Node2D) -> void:
	if body is CharacterBody2D:
		ResetLevel()

func ResetLevel():
	set_deferred("monitoring", false) # if this script is on an Area2D
	get_tree().call_deferred("reload_current_scene")
