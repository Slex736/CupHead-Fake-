extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func PlayerStanding(body: Node2D) -> void:
	if body is CharacterBody2D:
		animation_player.play("Falling")
		await animation_player.animation_finished
		queue_free()
