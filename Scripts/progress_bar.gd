extends TextureProgressBar

@export var CactusBoss: Area2D 


func Update():
	value =  CactusBoss.CurrentHealth
