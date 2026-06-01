extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale=Vector2.ONE*(1-Beat.beat_instance.get_beat_adherance())
	pass
