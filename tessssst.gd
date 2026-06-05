@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#return
	var offset=0
	for c in $base.get_children():
		c.global_position=Vector2.DOWN*offset*120
		offset+=1
		c.scale=Vector2(1.0,1.0)#*(offset/10)
		c.modulate=Color(0.0, 0.0, 0.0, 1.0)
	offset=0
	for c in $in.get_children():
		c.position=Vector2.DOWN*offset*120
		
		offset+=0.5
		#c.scale=Vector2(1.0,1.0)#*(offset/10)	
	pass
