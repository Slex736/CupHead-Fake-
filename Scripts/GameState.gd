extends Node

# 0 = normal, 1 = ice
var FloorType: int = 0

var levels = {
	[0, 0] : "res://Scenes/Levels/Tutorial/tutorial_level.tscn",
	[0, 1] : "res://Scenes/Levels/Mini/mini_level_1.tscn",
	[0, 2] : "res://Scenes/Levels/Mini/mini_level_2.tscn",
	[0, 3] : "res://Scenes/Levels/Mini/mini_level_3.tscn",
	[0, 4] : "res://Scenes/Levels/Mini/mini_level_4.tscn",
	[0, 5] : "res://Scenes/Levels/Mini/mini_level_5.tscn",
}

var LatestCheckPointPos = null


func _ready() -> void:
	current_level = get_tree().current_scene.scene_file_path

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("InGameSettings"):
		OpenInGameSettings()


# worlds 0 = tutorial, 1 = dune, 2 = ice, 3 = nether  
var completed_levels := {}  # Dictionary<[int, int], bool>
var current_level = [0, 0]

func mark_level_completed(WorldId: int, LevelId: int) -> void:
	completed_levels[[WorldId, LevelId]] = true

func is_level_completed(WorldId: int, LevelId: int) -> bool:
	return completed_levels.get([WorldId, LevelId], false)

func GetCurrentLevel():
	return levels.get(current_level, current_level)

func OpenInGameSettings():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/ingame_settings.tscn")
