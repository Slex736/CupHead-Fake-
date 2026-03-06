extends Control


func SoundPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/sound_interface.tscn")


func RestartPressed() -> void:
	get_tree().change_scene_to_file(GameState.GetCurrentLevel())


func HomePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/start_screen.tscn")
