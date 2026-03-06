extends Control



func SettingsPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/ingame_settings.tscn")
