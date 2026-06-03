extends Enemy


func shoot():
	return
func connect_action():
	beat.beat.connect(move.bind(Vector2.ZERO))
func max_proximity_to_player():
	return 0
func _on_hitbox_body_entered(body: Node2D) -> void:
	if hp<=0:return
	body.hit(10,color)
	pass # Replace with function body.
func set_color():
	color=colors.pick_random()
	#color=unlocked_colors.pick_random()
	if color=="Red":
		hp*=2
	$PointLight2D.color=color_dic[color]	
