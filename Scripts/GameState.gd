extends Node

var levels = {
	[0, 0] : "res://Scenes/Levels/Tutorial/tutorial_level.tscn",
	[0, 1] : "res://Scenes/Levels/Mini/mini_level_1.tscn",
	[0, 2] : "res://Scenes/Levels/Mini/mini_level_2.tscn",
	[0, 3] : "res://Scenes/Levels/Mini/mini_level_3.tscn",
	[0, 4] : "res://Scenes/Levels/Mini/mini_level_4.tscn",
	[0, 5] : "res://Scenes/Levels/Mini/mini_level_5.tscn",
}

# worlds 0 = tutorial, 1 = dune, 2 = ice, 3 = nether  

var completed_levels := {}  # Dictionary<[int, int], bool>
var current_level = [0, 0]

func mark_level_completed(WorldId: int, LevelId: int) -> void:
	completed_levels[[WorldId, LevelId]] = true

func is_level_completed(WorldId: int, LevelId: int) -> bool:
	return completed_levels.get([WorldId, LevelId], false)

func GetCurrentLevel():
	return levels.get(current_level, "res://Scenes/Levels/Tutorial/tutorial_level.tscn")
