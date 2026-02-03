extends Area2D

var animated_sprite
var player
var velocity:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_parent().get_parent().get_children()
	for i in children:
		if i.name == "Player":
			player = i
	velocity = get_velocity(global_position, player.global_position)
	
	var children_blue_enemy = get_parent().get_children()
	for x in children_blue_enemy:
		if x.name == "AnimatedSprite2D":
			animated_sprite = x 
	
	animated_sprite.play("Shooting")
	

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
func get_velocity(start_pos: Vector2, target_pos: Vector2) -> Vector2:
	var max_distance := 200.0
	var speed := 300.0

	var delta := target_pos - start_pos
	delta = delta.limit_length(max_distance)

	return delta.normalized() * speed
