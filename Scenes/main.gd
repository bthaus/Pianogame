extends Node2D

var x = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x = x + 1
	print(x)
	print("hello")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
