extends Control


func TutorialPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/tutorial_levels_ui.tscn")


func DunesPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/dunes_levels_ui.tscn")


func IcePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/ice_levels_ui.tscn")


func NetherPressed() -> void:
	pass # Replace with function body.
