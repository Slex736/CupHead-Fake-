extends Area2D

var InRange: bool = false



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and InRange:
		Dialogic.start("Priest")



func PlayerEntered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Dialogic.start("Interact")
		InRange = true



func PlayerExited(body: Node2D) -> void:
	if body is CharacterBody2D:
		InRange = false
