extends Node2D
var hp=5
signal destroyed
func hit(damage):
	hp-=damage
	if hp<=0:
		destroy()
func _ready() -> void:
	get_tree().create_timer(3).timeout.connect(destroy)

func destroy():
	queue_free()
	destroyed.emit()
	pass;
