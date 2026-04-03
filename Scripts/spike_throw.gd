extends Area2D

@export var ThrowDuration: float = 1.0

var PlayerPos: Vector2
var CactusPos: Vector2

var ThrowPeak: Vector2
var TargetPos: Vector2

var T: float = 0.0

var SpikeScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike.tscn")

@onready var CheckIfHitGround: RayCast2D = $RayCast2D

enum ThrowStates {
	Flying,
	Exploding,
}

var ThrowState =  ThrowStates.Flying

# get variables before loading the funcs
func Init(player_pos: Vector2, cactus_pos: Vector2):
	PlayerPos = player_pos
	CactusPos = cactus_pos

	CalcPeak()
	CalcTargetPos()



func CalcPeak():
	ThrowPeak.x = (PlayerPos.x + CactusPos.x) / 2
	ThrowPeak.y = min(PlayerPos.y, CactusPos.y) - 200

func CalcTargetPos():
	TargetPos.x = PlayerPos.x
	TargetPos.y = CactusPos.y

func _process(delta: float) -> void:
	HandleCurve(delta)
	
	HandleGroundCheck()
	
	if ThrowState == ThrowStates.Exploding:
		HandleExplosion()


func HandleCurve(delta):
	global_position = GameState._quadratic_bezier(CactusPos, ThrowPeak, TargetPos, T)
	
	if T > 0.1:
		CheckIfHitGround.collide_with_bodies = true
	
	T += delta / ThrowDuration



func HandleExplosion():
	var dir = Vector2(1, 0)
	
	for i in range(5):
		var Rotation = i * -45
		
		var SpikeInstance = SpikeScene.instantiate()
		SpikeInstance.dir = dir.rotated(deg_to_rad(Rotation))
		SpikeInstance.angle = deg_to_rad(Rotation)
		SpikeInstance.global_position = global_position
		
		get_tree().current_scene.add_child(SpikeInstance)  # neutral parent

	queue_free()


func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()

func HandleGroundCheck():
	if CheckIfHitGround.is_colliding():
		ThrowState = ThrowStates.Exploding
