extends Area2D


func PlayerInDeathZone(body: Node2D) -> void:
	get_tree().reload_current_scene()
