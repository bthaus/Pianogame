extends Sprite2D

var beat:Beat
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beat=Beat.get_beat_instance()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var adherance=beat.get_beat_adherance()
	material.set_shader_parameter("wave_amplitude",(1-adherance)/4.0)
	pass
