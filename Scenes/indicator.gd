extends Line2D
var default_pos
var active=false
var bps
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_pos=position
	var beat=Beat.get_beat_instance()
	bps=beat.bpm/60
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		default_color=Color(0,1,1,1)
		position.x += 75*bps * delta
	else:
		default_color=Color(1,1,1,1)	
		position=default_pos
	pass
