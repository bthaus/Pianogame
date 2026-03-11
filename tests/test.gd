extends Node2D
signal test
func test_signal(s:String):
	print(s)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test.connect(test_signal.bind("hi"))
	test.emit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
