extends Node2D

@export var backdrop:Texture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if backdrop!=null:$Parallax2D/BackgroundCastles.texture=backdrop
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
