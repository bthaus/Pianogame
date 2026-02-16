extends Node2D

signal beat
signal bar
signal open_window
signal close_window
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_beat(4,4,180,0.07)
	pass # Replace with function body.

# Godot GDScript
func set_beat(x: int, y: int, bpm: float,tolerance:float):
	var dic=get_beat(x,y,bpm)
	$beat.wait_time=dic["beat_duration"]
	$bar.wait_time=dic["bar_duration"]
	$open_window.wait_time=dic["beat_duration"]
	$close_window.wait_time=dic["beat_duration"]
	$open_window.start()
	await get_tree().create_timer(tolerance/2).timeout
	$beat.start()
	$bar.start()
	await get_tree().create_timer(tolerance).timeout
	$close_window.start()
	
	pass
func beat_timeout():
	$beatsound.play(0)
	print("beat "+str(Time.get_ticks_msec()))
	pass
func bar_timeout():
	$barsound.play()
	pass;
func get_beat(x: int, y: int, bpm: float) -> Dictionary:
	"""
	x: obere Zahl der Taktart (Anzahl der Schläge pro Takt)
	y: untere Zahl der Taktart (Notenwert, der einen Schlag bekommt, z.B. 4 = Viertel)
	bpm: Tempo in Schlägen pro Minute
	
	Gibt ein Dictionary zurück mit:
	- beat_duration: Dauer eines Schlages in Sekunden
	- measure_duration: Dauer eines Takts in Sekunden
	"""
	
	# Dauer eines einzelnen Schlages in Sekunden
	var beat_duration = 60.0 / bpm
	
	# Dauer eines Taktes
	var measure_duration = beat_duration * x
	
	return {
		"beat_duration": beat_duration,
		"bar_duration": measure_duration
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open_window_timeout() -> void:
	open_window.emit()
	print("open "+str(Time.get_ticks_msec()))
	pass # Replace with function body.


func _on_close_window_timeout() -> void:
	close_window.emit()
	print("close "+str(Time.get_ticks_msec()))
	pass # Replace with function body.
