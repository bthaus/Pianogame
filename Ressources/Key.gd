extends Resource
class_name Note
@export	var key:String
@export	var delay:int
var _timestamp:int
func _init(key:String,delay:int) -> void:
	self.key=key
	self.delay=delay
	_timestamp=Time.get_ticks_msec()
