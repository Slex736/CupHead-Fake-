extends Area2D

var PlayerPos: Vector2
var CactusPos: Vector2

var TargetPos: Vector2
var PeakPos: Vector2
var StartPos: Vector2

var TopStageY: int = -160

var FlyT: float = 0.0
var FlyUpDuration: float = 1.5

var CactusYOffset: int = -40

var FallSpeed: int = 100

enum SpikeBallStates {
	Idle,
	GoingUp,
	Fall,
}

var SpikeBallState = SpikeBallStates.Idle

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var spike_shoot: Timer = $SpikeShoot

var SpikeScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike.tscn")


func Init(player_pos: Vector2, cactus_pos: Vector2):
	PlayerPos = player_pos
	CactusPos = cactus_pos
	
	
	CalcStartPos()
	CalcTargetPos()
	CalcPeakPos()
	
	SpikeBallState = SpikeBallStates.GoingUp

func _process(delta: float) -> void:
	if SpikeBallState == SpikeBallStates.GoingUp:
		FlyToTopPos(delta)
	if SpikeBallState == SpikeBallStates.Fall:
		HandleFall(delta)


func FlyToTopPos(delta):
	global_position = GameState._quadratic_bezier(StartPos, PeakPos, TargetPos, FlyT)
	
	FlyT += delta / FlyUpDuration
	FlyT = clamp(FlyT, 0.0, 1.0)
	
	if FlyT == 1.0:
		SpikeBallState = SpikeBallStates.Fall

func HandleFall(delta):
	global_position.y += FallSpeed * delta

func CalcStartPos():
	StartPos.x = CactusPos.x
	StartPos.y = CactusPos.y + CactusYOffset

func CalcTargetPos():
	TargetPos.x = PlayerPos.x
	TargetPos.y = TopStageY

func CalcPeakPos():
	PeakPos.x = (PlayerPos.x + CactusPos.x) / 2
	PeakPos.y = TargetPos.y


func BodyenteredHitbox(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
	else:
		queue_free()


func ShootSpikes():
	var dir = Vector2(1, 0)
	
	for i in range(2):
		var Rotation = i * -180
		
		var SpikeInstance = SpikeScene.instantiate()
		SpikeInstance.dir = dir.rotated(deg_to_rad(Rotation))
		SpikeInstance.angle = deg_to_rad(Rotation)
		SpikeInstance.global_position = global_position
		
		get_tree().current_scene.add_child(SpikeInstance)


func SpikeShootTimeout() -> void:
	if SpikeBallState == SpikeBallStates.Fall:
		ShootSpikes()
	RotateBall()
	spike_shoot.start()

func RotateBall():
	sprite_2d.rotate(deg_to_rad(45))
