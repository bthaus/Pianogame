extends Node2D
var max_hp
var hp=5:
	set(val):
		hp=clamp(val,0,100000)
		shield_hp_changed.emit()
		if hp<=0:
			destroy()

signal shield_hp_changed()
signal destroyed(shield)

func _ready() -> void:
	shield_hp_changed.emit()
	get_tree().create_timer(3).timeout.connect(func():hp=0)

func destroy():
	
	queue_free()
	destroyed.emit(self)
	pass;
