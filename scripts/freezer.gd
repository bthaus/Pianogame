extends Timer
class_name Freezer
var time
var active=true
func _ready() -> void:
	start(time)
	timeout.connect(remove)
func _init(time) -> void:
	self.time=time	
func _process(delta: float) -> void:
	if get_parent() is Boss:queue_free()
	if active:get_parent().frozen=true
func remove():
	get_parent().frozen=false
	active=false
	queue_free()
	pass	
