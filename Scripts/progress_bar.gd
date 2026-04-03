extends TextureProgressBar

@export var CactusBoss: Area2D 


func Update():
	print(CactusBoss.CurrentHealth)
	value =  CactusBoss.CurrentHealth
