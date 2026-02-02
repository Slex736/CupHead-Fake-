extends Area2D


@onready var HeadBumpAnimation: AnimatedSprite2D = $AnimatedSprite2D




func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	# local_shape_index = Headbump Collision 2d and the player is interacting with it.
	if body is CharacterBody2D and local_shape_index == 1:
		HeadBumpAnimation.play("Bumped")

func _process(_delta: float) -> void:
	if not HeadBumpAnimation.animation == "Bumped" and HeadBumpAnimation.is_playing():
		print("deleting")
