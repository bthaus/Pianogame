extends Timer

var last_trigger_time: float = 0.0


func _ready() -> void:
	timeout.connect(_on_timeout)
	last_trigger_time = Time.get_ticks_msec() / 1000.0


func _on_timeout() -> void:
	last_trigger_time = Time.get_ticks_msec() / 1000.0


func get_trigger_value() -> float:
	var to_next: float = time_left

	var now: float = Time.get_ticks_msec() / 1000.0
	var since_last: float = now - last_trigger_time

	var nearest: float = minf(to_next, since_last)

	var half_cycle: float = wait_time * 0.5

	# map: 0 -> 0, half_cycle -> 1
	return remap(nearest, 0.0, half_cycle, 0.0, 1.0)
