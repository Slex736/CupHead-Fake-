extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var projectilescene = preload("res://Scenes/blue_enemy_projectile.tscn")
var projectile

@export var radius = 50
var PlayerInRadius = false

var tickcounter = 0
var ShootDelay = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision_shape_2d.shape is CircleShape2D:
		collision_shape_2d.shape.radius = radius
	



func _process(delta: float) -> void:
	tickcounter += 1 * delta
	if tickcounter > 1 and PlayerInRadius:
		ShootBall()
		tickcounter = 0


func ShootBall():
	projectile = projectilescene.instantiate()
	add_child(projectile)
	projectile.global_position = global_position





func PlayerEnteredShootingRadius(body: Node2D) -> void:
	if body is CharacterBody2D:
		PlayerInRadius = true


func PlayerLeavingShootingRadius(body: Node2D) -> void:
	if body is CharacterBody2D:
		PlayerInRadius = false
