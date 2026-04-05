extends Area2D

@onready var MaxHealth: int = 100
@onready var CurrentHealth: int = MaxHealth

var Speed: float = 100.0

@export var RightPos: Vector2
@export var LeftPos: Vector2

var StartPos: Vector2
var PeakPos: Vector2
var EndPos: Vector2

# how long has the rout gone so 0.50 is 50 % of the path completed
var T: float = 0.0

# time it takes to go from left to right in secs
var Duration: float = 5.0

@onready var player: CharacterBody2D = $"../../Player"

var SpikeThrowScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_throw.tscn")
var SpikeFallScene = preload("res://Scenes/Enemies/BossAttackProjectiles/spike_ball_fall.tscn")
var WarnTileScene = preload("res://Scenes/Enemies/BossAttackProjectiles/warn_tile.tscn")
var CactusAttackScene = preload("res://Scenes/Enemies/BossAttackProjectiles/cactus_attack.tscn")

@onready var progress_bar: TextureProgressBar = $CanvasLayer/ProgressBar

@onready var tilemap: TileMap = $"../../Tilemap"

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D

var SpawnablesTilesWorldPos: Array[Vector2] = []
var SelectedTiles: Array[Vector2] = []

# use to offset the warn tiles from given y cords by selected tiles
const WarnTilesOffsetY: int = -24
# use to offset cactus from warntile to make it start from underground
const CactusOffsetY: int  = 24

enum CactusBossStates {
	Idle,
	SpikeThrow,
	SpikeFall,
	CactusRaise,
}

# store the direction
enum CactusBossFlyStates {
	Still,
	Left,
	Right,
}

var CactusBossState = CactusBossStates.Idle
var CactusBossFlyState = CactusBossFlyStates.Left


var CanAttack: bool = false
var IsAttacking: bool = false
var CanMove: bool = true

func _ready() -> void:
	progress_bar.Update()
	
	# calc StartPos PeakPos and EndPos
	CalcFlyVariables()
	
	Combo1()



func _process(delta: float) -> void:
	
	if CanMove:
		HandleMovement(delta)
	

	if CurrentHealth > 0:
		HandleHealthUpdates()
	
	if IsAttacking == false: 
		if CactusBossState == CactusBossStates.SpikeThrow:
			SpikeThrow()
		elif CactusBossState == CactusBossStates.SpikeFall:
			SpikeFall()
		elif CactusBossState == CactusBossStates.CactusRaise:
			CactusRaise()


# load Spike Throw and give info so it can use bezier func to make an arch
func SpikeThrow():
	CactusBossState = CactusBossStates.Idle
	
	Animations.play("SpikeSpit")
	
	await wait_for_frame(8)
	
	var SpikeThrowInstance = SpikeThrowScene.instantiate()
	SpikeThrowInstance.Init(player.global_position, global_position)
	get_tree().current_scene.add_child(SpikeThrowInstance)  # neutral parent
	




func SpikeFall():
	CactusBossState = CactusBossStates.Idle
	
	Animations.play("PlantAttack")
	await Animations.animation_finished
	
	var SpikeFallInstance = SpikeFallScene.instantiate()
	SpikeFallInstance.Init(player.global_position, global_position)
	get_tree().current_scene.add_child(SpikeFallInstance)  # neutral parent
	
	Animations.play("PlantRegen")
	CactusBossFlyState = CactusBossFlyStates.Still
	await Animations.animation_finished
	await get_tree().create_timer(2.0).timeout
	CactusBossFlyState = CactusBossFlyStates.Right


func CactusRaise():
	
	CalcSpawnTiles()
	
	SelectTiles()
	
	SpawnDangerTiles()

	CactusBossState = CactusBossStates.Idle
	SpawnablesTilesWorldPos = []
	SelectedTiles = []

func CalcSpawnTiles():
	var SpawnableTiles = tilemap.get_used_cells_by_id(0, 0, Vector2i(2, 0))
	for tile in SpawnableTiles:
		var world_pos = tilemap.map_to_local(tile)
		SpawnablesTilesWorldPos.append(world_pos)

func SelectTiles():
	SpawnablesTilesWorldPos.shuffle()
	
	# calc half of total size of tiles
	var HalfCount = SpawnablesTilesWorldPos.size() / 4.0 * 3.0 # get 3/4 of all blocks
	
	SelectedTiles = SpawnablesTilesWorldPos.slice(0, HalfCount)


func SpawnDangerTiles():
	for i in SelectedTiles:
		var WarnTileInstance = WarnTileScene.instantiate()
		i.y += WarnTilesOffsetY
		WarnTileInstance.global_position = i
		get_tree().current_scene.add_child(WarnTileInstance)  # neutral parent

func SpawnCactus(Pos: Vector2):
	var CactusAttackInstance = CactusAttackScene.instantiate()
	CactusAttackInstance.MaxHeight = Pos.y + 8 # offset to make cactus stand on the block
	Pos.y += CactusOffsetY
	CactusAttackInstance.global_position = Pos
	get_tree().current_scene.add_child(CactusAttackInstance)  # neutral parent

func CalcFlyVariables():
	CalcStartPos()
	
	CalcEndPos()
	
	CalcPeakPos()

func CalcStartPos():
	if CactusBossFlyState == CactusBossFlyStates.Left:
		StartPos = RightPos
	elif CactusBossFlyState == CactusBossFlyStates.Right:
		StartPos = LeftPos

func CalcEndPos():
	if CactusBossFlyState == CactusBossFlyStates.Left:
		EndPos = LeftPos
	elif CactusBossFlyState == CactusBossFlyStates.Right:
		EndPos = RightPos

func CalcPeakPos():
	PeakPos.x = (StartPos.x + EndPos.x) / 2
	PeakPos.y = ((StartPos.y + EndPos.y) / 2) - 200 # offset to raise it into the air

func HandleMovement(delta):
	if CactusBossFlyState != CactusBossFlyStates.Still:
		global_position = GameState._quadratic_bezier(StartPos, PeakPos, EndPos, T)
		
		T += delta / Duration
		T = clamp(T, 0.0, 1.0)
		
		if T == 1.0:
			T = 0.0
			CactusBossFlyState = CactusBossFlyStates.Still
			ChooseDirection()


func ChooseDirection():
	await get_tree().create_timer(2.0).timeout

	if global_position.distance_to(LeftPos) < 1.0:
		CactusBossFlyState = CactusBossFlyStates.Right
	if global_position.distance_to(RightPos) < 1.0:
		CactusBossFlyState = CactusBossFlyStates.Left
		
	CalcFlyVariables()

func wait_for_frame(target_frame: int):
	while Animations.frame < target_frame:
		await Animations.frame_changed

func Combo1():
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.CactusRaise
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(3.0).timeout
	CactusBossState = CactusBossStates.CactusRaise
	await get_tree().create_timer(3.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeFall
	
	await get_tree().create_timer(7.0).timeout
	Combo2()

func Combo2():
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(3.0).timeout
	CactusBossState = CactusBossStates.CactusRaise
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(3.0).timeout
	CactusBossState = CactusBossStates.CactusRaise
	
	await get_tree().create_timer(2.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	await get_tree().create_timer(1.5).timeout
	CactusBossState = CactusBossStates.SpikeThrow
	

	await get_tree().create_timer(1.0).timeout
	CactusBossState = CactusBossStates.SpikeFall
	await get_tree().create_timer(7.0).timeout
	
	Combo1()

func HandleHealthUpdates():
	pass
