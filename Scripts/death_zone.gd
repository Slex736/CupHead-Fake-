extends Area2D


func PlayerInDeathZone(_body: Node2D) -> void:
	get_tree().reload_current_scene()
