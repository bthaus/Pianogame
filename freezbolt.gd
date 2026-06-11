extends HomingProjectile
class_name FreezeProjectile

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var freezer=Freezer.new(clamp(2-error_count,0,2))
		body.add_child(freezer)
	
		
	super(body)
	pass
