extends Area2D

var speed = 200

var dir: Vector2 
var angle: float = 0.0

var StartPos: Vector2

func _ready() -> void:
	rotation = angle
	StartPos = global_position

func _process(delta: float) -> void:
	global_position += dir * speed * delta
	
	var Distance = (StartPos - global_position).length()
	if Distance > 1000:
		queue_free()


func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameState.OpenInGameSettings()
	else:
		queue_free()
