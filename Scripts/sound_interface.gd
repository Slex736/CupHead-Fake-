extends Control

@onready var SoundSlider = $HSlider

func _ready() -> void:
	SoundSlider.value = SoundScript.sound

func SoundOffPressed() -> void:
	SoundSlider.value = 0
	SoundScript.sound = 0


func SoundOnPressed() -> void:
	SoundSlider.value = 1
	SoundScript.sound = 1


func ValueChangedOfSoundSlider(value: float) -> void:
	var busSFX = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(busSFX, linear_to_db(value))
	SoundScript.sound = value


func HomePressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/start_screen.tscn")
