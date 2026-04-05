extends Node2D

@onready var cactus_boss_1: Area2D = $"../Enemies/CactusBoss1"

func _ready():
	await get_tree().create_timer(0.5).timeout
	await flicker()

func flicker():
	await flicker_phase(0.2, 2)
	await flicker_phase(0.1, 3)
	await flicker_phase(0.05, 4)
	
	cactus_boss_1.SpawnCactus(global_position)
	
	queue_free()


func flicker_phase(delay: float, times: int):
	for i in range(times):
		visible = false
		await get_tree().create_timer(delay).timeout
		visible = true
		await get_tree().create_timer(delay).timeout
