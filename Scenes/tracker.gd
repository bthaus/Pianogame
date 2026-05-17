extends Sprite2D
class_name Tracker
var target:Enemy



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible=target!=null
	if target==null:return
	global_position=target.center.global_position
	pass
