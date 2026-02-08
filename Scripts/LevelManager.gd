extends Node

var UIPath = "res://Scenes/UI/tutorial_ui.tscn"

func load_ui():
	get_tree().call_deferred("change_scene_to_file", UIPath)
