extends HomingProjectile
class_name FreezeProjectile

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.frozen=true
		get_tree().create_timer(clamp(2-error_count,0,2)).timeout.connect(func():
			if !is_instance_valid(body):return
			body.frozen=false)
	super(body)
	pass
