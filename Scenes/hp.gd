extends ProgressBar
@export var player:Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_node_2d_hp_changed() -> void:
	max_value=player.max_hp
	value=player.hp
	var t=1
	var color=remap(player.hp,0,player.max_hp,0,t)
	self_modulate=Color(t-color,color,0,t)
	pass # Replace with function body.
