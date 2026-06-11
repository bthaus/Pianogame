extends EnemyScanner


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node2D) -> void:
	overlapping_enemies.append(body)
	#body.died.connect(_on_body_exited.bind(body))
	current_target=overlapping_enemies.front()	
	pass # Replace with function body.
func _process(delta: float) -> void:
	var nearest=10000000000000
	var tempt=null
	#for e in overlapping_enemies:
		#var distance=e.global_position-player.global_position
		#if distance.x>0 and player.face_direction.x<0 or distance.x<0 and player.face_direction.x>0:
			##distance*2
			#continue
		#distance=distance.length_squared()
		#player.face_direction
		#if distance<nearest:
			#nearest=distance
			#tempt=e
	#if tempt!=null and current_target!=tempt and is_instance_valid(tempt):		
		#current_target=tempt
	pass
func next_target():
	var shift=overlapping_enemies.pop_front()
	overlapping_enemies.push_back(shift)
	current_target=overlapping_enemies.front()
	return current_target
	pass
func _on_body_exited(body: Node2D) -> void:
	
	overlapping_enemies.erase(body)
	if overlapping_enemies.is_empty():current_target=null	
	else:current_target=overlapping_enemies.front()	
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	_on_body_entered(area)
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	_on_body_exited(area)
	pass # Replace with function body.
