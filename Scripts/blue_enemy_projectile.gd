extends Area2D

@onready var blue_enemy_projectile: Area2D = $"."

var animated_sprite
var player
var velocity:Vector2

var step
var TravelledDistanceStep 
var TravelledDistanceTotal: float = 0.0

var HasBeenShot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# play animation
	var children_blue_enemy = get_parent().get_children()
	for x in children_blue_enemy:
		if x.name == "AnimatedSprite2D":
			animated_sprite = x 
	
	animated_sprite.play("Shooting")
	# wait for it to finish before launching the ball
	animated_sprite.animation_finished.connect(ShootBall)
	
	# find player and determine angle
	var children = get_parent().get_parent().get_children()
	for i in children:
		if i.name == "Player":
			player = i
	velocity = get_velocity(global_position, player.global_position)
	

func _physics_process(delta: float) -> void:
	step = velocity * delta
	# see if the animation has finished to start adding velocity
	if HasBeenShot == true:
		global_position += velocity * delta
	
	if step.x != null:
		TravelledDistanceStep = ((step.x ** 2) + (step.y ** 2)) ** 0.5
		TravelledDistanceTotal += TravelledDistanceStep
		
		if TravelledDistanceTotal > 1000:
			queue_free()

# determine velocity
func get_velocity(start_pos: Vector2, target_pos: Vector2) -> Vector2:
	var max_distance := 200.0
	var speed := 300.0

	var delta := target_pos - start_pos
	delta = delta.limit_length(max_distance)

	return delta.normalized() * speed
	
func ShootBall():
	if HasBeenShot == false:
		var children_blue_enemy = get_parent().get_children()
		for x in children_blue_enemy:
			if x.name == "AnimatedSprite2D":
				animated_sprite = x 
		
		animated_sprite.play("default")
		
		blue_enemy_projectile.visible = true
		
		HasBeenShot = true




func ContactWithPlayerOrWall(body: Node2D) -> void:
	if body is CharacterBody2D:
		set_deferred("monitoring", false) # if this script is on an Area2D
		get_tree().call_deferred("reload_current_scene")
	queue_free()
	
