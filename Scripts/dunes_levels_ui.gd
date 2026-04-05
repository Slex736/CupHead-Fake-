extends Control

var level_unable_buttons = {}
var level_locked_buttons = {}

@onready var boss_level_unlocked: TextureButton = $BossLevelUnlocked
@onready var boss_level_locked: TextureButton = $BossLevelLocked

func _ready():
	for i in range(1, 6):  # for levels 1–5
		level_unable_buttons[i] = get_node("Level" + str(i) + "Unable")
		level_locked_buttons[i] = get_node("Level" + str(i) + "Locked")
	CheckLevels()
	
	CheckIfDuneWorldIsUnlocked()
	
	if GameState.BossLevelDunesUnlocked:
		boss_level_locked.visible = false
		boss_level_unlocked.visible = true
		boss_level_unlocked.disabled = false

func show_level_unable(level):
	if level_unable_buttons.has(level):
		level_unable_buttons[level].visible = true
		level_unable_buttons[level].disabled = false
	if level_locked_buttons.has(level):
		level_locked_buttons[level].visible = false

func CheckLevels():
	for x in range(0, 6):
		if GameState.is_level_completed(1, x):
			UnlockNextLevel(x)

func UnlockNextLevel(CurrentLevel):
	show_level_unable(CurrentLevel + 1)

func CheckIfDuneWorldIsUnlocked():
	if GameState.WorldUnlocked.get(1) == true:
		show_level_unable(1)



func Level1Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Dunes/lv_1_dunes.tscn")
	GameState.current_level = [1, 1]
	GameState.LatestCheckPointPos = null


func Level2Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Dunes/lv_2_dunes.tscn")
	GameState.current_level = [1, 2]
	GameState.LatestCheckPointPos = null

func Level3Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Dunes/lv_3_dunes.tscn")
	GameState.current_level = [1, 3]
	GameState.LatestCheckPointPos = null

func Level4Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Dunes/lv_4_dunes.tscn")
	GameState.current_level = [1, 4]
	GameState.LatestCheckPointPos = null

func Level5Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Dunes/lv_5_dunes.tscn")
	GameState.current_level = [1, 5]
	GameState.LatestCheckPointPos = null


func ArrowBackPressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/worlds_interface.tscn")
	GameState.LatestCheckPointPos = null

func HomePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/start_screen.tscn")
	GameState.LatestCheckPointPos = null


func BossLevelPressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/BossFights/boss_fight_desert.tscn")
	GameState.LatestCheckPointPos = null
	GameState.current_level = [1, 6]
