extends Node2D


@export var Level: PackedScene

func On_button_pressed() -> void:
	LoadLevel(Level)


func LoadLevel(level):
	get_tree().change_scene_to_file(level.resource_path)
