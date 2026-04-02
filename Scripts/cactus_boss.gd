extends Area2D


@onready var player: CharacterBody2D = $"../../Player"

var SpikeThrowScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_throw.tscn")
var SpikeFallScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_ball_fall.tscn")


enum CactusBossStates {
	Idle,
	SpikeThrow,
	SpikeFall,
}

var CactusBossState = CactusBossStates.SpikeFall


func _process(_delta: float) -> void:
	#if randi() % 200 == 0:
		#CactusBossState = CactusBossStates.SpikeThrow
	
	
	if CactusBossState == CactusBossStates.SpikeThrow:
		SpikeThrow()
	elif CactusBossState == CactusBossStates.SpikeFall:
		SpikeFall()


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
