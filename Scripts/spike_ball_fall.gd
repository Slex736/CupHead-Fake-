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
