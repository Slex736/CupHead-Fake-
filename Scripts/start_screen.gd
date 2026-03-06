extends Control

var LevelsUI = preload("res://Scenes/UI/worlds_interface.tscn")
var TutorialLevelScene = preload("res://Scenes/Levels/Tutorial/tutorial_level.tscn")
var SoundInterfaceScene = preload("res://Scenes/UI/sound_interface.tscn")


func PlayPressed() -> void:
	get_tree().change_scene_to_packed(TutorialLevelScene)
	GameState.current_level = [0, 0]


func LevelsPressed() -> void:
	get_tree().change_scene_to_packed(LevelsUI)


func SoundPressed() -> void:
	get_tree().change_scene_to_packed(SoundInterfaceScene)
