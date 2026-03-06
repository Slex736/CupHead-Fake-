extends Control

var level_unable_buttons = {}
var level_locked_buttons = {}


func _ready():
	for i in range(1, 6):  # for levels 1–5
		level_unable_buttons[i] = get_node("Level" + str(i) + "Unable")
		level_locked_buttons[i] = get_node("Level" + str(i) + "Locked")
	CheckLevels()

func show_level_unable(level):
	if level_unable_buttons.has(level):
		level_unable_buttons[level].visible = true
		level_unable_buttons[level].disabled = false
	if level_locked_buttons.has(level):
		level_locked_buttons[level].visible = false

func CheckLevels():
	for x in range(0, 6):
		if GameState.is_level_completed(0, x):
			UnlockNextLevel(x)

func UnlockNextLevel(CurrentLevel):
	show_level_unable(CurrentLevel + 1)

func Level1Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Mini/mini_level_1.tscn")


func Level2Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Mini/mini_level_2.tscn")


func Level3Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Mini/mini_level_3.tscn")


func Level4Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Mini/mini_level_4.tscn")


func Level5Pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Mini/mini_level_5.tscn")


func ArrowBackPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/worlds_interface.tscn")


func HomePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/start_screen.tscn")
