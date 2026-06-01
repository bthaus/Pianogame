extends Parallax2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("connect_beat")
	pass # Replace with function body.

func connect_beat():
	Beat.get_beat_instance().beat.connect(move)
	pass
func move():
	var tw=create_tween()
	tw.tween_property(self,^"scroll_offset",scroll_offset+Vector2.RIGHT*15,60/Beat.get_beat_instance().bpm/2)
	tw.set_ease(Tween.EASE_OUT)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
