extends Area2D

@onready var MaxHealth: int = 100
@onready var CurrentHealth: int = MaxHealth

@onready var player: CharacterBody2D = $"../../Player"

var SpikeThrowScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_throw.tscn")
var SpikeFallScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_ball_fall.tscn")

@onready var progress_bar: TextureProgressBar = $CanvasLayer/ProgressBar

enum CactusBossStates {
	Idle,
	SpikeThrow,
	SpikeFall,
	CactusRaise,
}

var CactusBossState = CactusBossStates.Idle

func _ready() -> void:
	progress_bar.Update()

func _process(_delta: float) -> void:
	
	
	if CactusBossState == CactusBossStates.SpikeThrow:
		SpikeThrow()
	elif CactusBossState == CactusBossStates.SpikeFall:
		SpikeFall()
	elif CactusBossState == CactusBossStates.CactusRaise:
		CactusRaise()


# load Spike Throw and give info so it can use bezier func to make an arch
func SpikeThrow():
	var SpikeThrowInstance = SpikeThrowScene.instantiate()
	SpikeThrowInstance.Init(player.global_position, global_position)
	add_child(SpikeThrowInstance)
	
	
	CactusBossState = CactusBossStates.Idle


func SpikeFall():
	var SpikeFallInstance = SpikeFallScene.instantiate()
	SpikeFallInstance.Init(player.global_position, global_position)
	add_child(SpikeFallInstance)
	
	CactusBossState = CactusBossStates.Idle

func CactusRaise():
	pass
