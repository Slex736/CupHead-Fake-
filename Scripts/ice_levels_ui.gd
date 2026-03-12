extends Control

var level_unable_buttons = {}
var level_locked_buttons = {}


func _ready():
	for i in range(1, 6):  # for levels 1–5
		level_unable_buttons[i] = get_node("Level" + str(i) + "Unable")
		level_locked_buttons[i] = get_node("Level" + str(i) + "Locked")
	CheckLevels()
	
	CheckIfIceWorldIsUnlocked()

func show_level_unable(level):
	if level_unable_buttons.has(level):
		level_unable_buttons[level].visible = true
		level_unable_buttons[level].disabled = false
	if level_locked_buttons.has(level):
		level_locked_buttons[level].visible = false

func CheckLevels():
	for x in range(0, 6):
		if GameState.is_level_completed(2, x):
			UnlockNextLevel(x)

func UnlockNextLevel(CurrentLevel):
	show_level_unable(CurrentLevel + 1)

func CheckIfIceWorldIsUnlocked():
	if GameState.WorldUnlocked.get(2) == true:
		show_level_unable(1)
	



func Level1Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Ice/lv1Frostyforest.tscn")
	GameState.current_level = [2, 1]
	GameState.LatestCheckPointPos = null


func Level2Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Ice/lv2Frostycave.tscn")
	GameState.current_level = [2, 2]
	GameState.LatestCheckPointPos = null

func Level3Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Ice/lv3Forstytunnel.tscn")
	GameState.current_level = [2, 3]
	GameState.LatestCheckPointPos = null

func Level4Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Ice/lv4Frostycrevasses.tscn")
	GameState.current_level = [2, 4]
	GameState.LatestCheckPointPos = null

func Level5Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Worlds/Ice/lv5Frostypeaks.tscn")
	GameState.current_level = [2, 5]
	GameState.LatestCheckPointPos = null

func ArrowBackPressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/worlds_interface.tscn")
	GameState.LatestCheckPointPos = null

func HomePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/start_screen.tscn")
	GameState.LatestCheckPointPos = null
