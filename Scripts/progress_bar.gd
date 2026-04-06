extends TextureProgressBar


@onready var CactusBoss: Area2D = $"../.."


func Update():
	value = CactusBoss.CurrentHealth
