extends Area2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



func Headbump(body: Node2D) -> void:
	if body is CharacterBody2D:
		animation_player.play("Bumped")


func HeadbumpAnimationsFinished(_anim_name: StringName) -> void:
	get_parent().queue_free()
