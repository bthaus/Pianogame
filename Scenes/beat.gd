extends Timer

var last_trigger_time: float = 0.0


func _ready() -> void:
	timeout.connect(_on_timeout)
	last_trigger_time = Time.get_ticks_msec() / 1000.0


func _on_timeout() -> void:
	last_trigger_time = Time.get_ticks_msec() / 1000.0


@onready var player:AudioStreamPlayer2D=$'../base'
func get_trigger_value() -> float:
	var current=player.get_playback_position()
	var beat_time=60.0/90.0
	var exact_beat=current/beat_time-0.3
	var last_beat_count=floor(current/beat_time)
	var next_beat_count=ceil(current/beat_time)
	var in_between=exact_beat-last_beat_count
	if in_between<0.5:
		in_between= in_between
	else: in_between= (1-in_between)	
	return clamp(in_between*2,0.0,1.0)
