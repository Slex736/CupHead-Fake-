extends Node

# 0 = normal, 1 = ice
var FloorType: int = 0

var LatestCheckPointPos = null

# check if its open so when space bar is clicked and is open the level resets
var InGameSettingOpen: bool = false


# store if dash has been unlocked
var DashUnlocked: bool = true


# worlds 0 = tutorial, 1 = dune, 2 = ice, 3 = nether  
var WorldUnlocked = {
	0 : true,
	1 : false,
	2 : false,
	3 : false,
}

var levels = {
	[0, 0] : "res://Scenes/Levels/Tutorial/tutorial_level.tscn",
	[0, 1] : "res://Scenes/Levels/Mini/mini_level_1.tscn",
	[0, 2] : "res://Scenes/Levels/Mini/mini_level_2.tscn",
	[0, 3] : "res://Scenes/Levels/Mini/mini_level_3.tscn",
	[0, 4] : "res://Scenes/Levels/Mini/mini_level_4.tscn",
	[0, 5] : "res://Scenes/Levels/Mini/mini_level_5.tscn",
	[1, 1] : "res://Scenes/Levels/Worlds/Dunes/lv_1_dunes.tscn",
	[1, 2] : "res://Scenes/Levels/Worlds/Dunes/lv_2_dunes.tscn",
	[1, 3] : "res://Scenes/Levels/Worlds/Dunes/lv_3_dunes.tscn",
	[1, 4] : "res://Scenes/Levels/Worlds/Dunes/lv_4_dunes.tscn",
	[1, 5] : "res://Scenes/Levels/Worlds/Dunes/lv_5_dunes.tscn",
	[2, 1] : "res://Scenes/Levels/Worlds/Ice/lv1Frostyforest.tscn",
	[2, 2] : "res://Scenes/Levels/Worlds/Ice/lv2Frostycave.tscn",
	[2, 3] : "res://Scenes/Levels/Worlds/Ice/lv3Forstytunnel.tscn",
	[2, 4] : "res://Scenes/Levels/Worlds/Ice/lv4Frostycrevasses.tscn",
	[2, 5] : "res://Scenes/Levels/Worlds/Ice/lv5Frostypeaks.tscn",
}

func _ready() -> void:
	current_level = get_tree().current_scene.scene_file_path

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("InGameSettings"):
		OpenInGameSettings()
	
	if InGameSettingOpen and Input.is_action_just_pressed("ResetLevel"):
		get_tree().change_scene_to_file(GetCurrentLevel())
		InGameSettingOpen = false


# worlds 0 = tutorial, 1 = dune, 2 = ice, 3 = nether  
var completed_levels := {}  # Dictionary<[int, int], bool>
var current_level = [0, 0]

func mark_level_completed(WorldId: int, LevelId: int) -> void:
	completed_levels[[WorldId, LevelId]] = true

func is_level_completed(WorldId: int, LevelId: int) -> bool:
	return completed_levels.get([WorldId, LevelId], false)

func OpenInGameSettings():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/ingame_settings.tscn")
	InGameSettingOpen = true
	

func GetCurrentLevel():
	return levels.get(current_level, current_level)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
