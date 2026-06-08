extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(connect_beat)
	pass # Replace with function body.
func connect_beat():
	
	Beat.get_beat_instance().beat.connect(func():
		frame=(frame+1)%2
		$PointLight2D.energy=1+randf_range(-0.25,0.25)
		
		pass)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
