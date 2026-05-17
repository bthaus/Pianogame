extends Node2D
var hp=5
signal destroyed
func hit(damage):
	hp-=damage
	if hp<=0:
		queue_free()
		destroyed.emit()
