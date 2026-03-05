extends Control

@onready var SoundButton = $Buttons/Sound
@onready var PlayButton = $Buttons/Play
@onready var LevelButton = $Buttons/Levels

var ScreenSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScreenSize = DisplayServer.screen_get_size()
	
	PlaceButtons()

func PlaceButtons():
	PlaceSoundButton()
	PlacePlayButton()
	PlaceLevelsButton()

func PlaceSoundButton():
	SoundButton.position.y = ScreenSize.y / 2 - (ScreenSize.y / 10)
	SoundButton.position.x = (ScreenSize.x / 2 - (ScreenSize.x / 20)) * -1

func PlacePlayButton():
	PlayButton.position.y = (ScreenSize.y / 8) * -1

func PlaceLevelsButton():
	LevelButton.position.y = ScreenSize.y / 2 - (ScreenSize.y / 10) 
	LevelButton.position.x = (ScreenSize.x / 2 - (ScreenSize.x / 20) - 100) 
