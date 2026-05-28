extends Enemy

func shoot():
	return
func connect_action():
	beat.beat.connect(move.bind(Vector2.ZERO))
func max_proximity_to_player():
	return 0
func _on_hitbox_body_entered(body: Node2D) -> void:
	if hp<=0:return
	body.hit(10)
	pass # Replace with function body.
