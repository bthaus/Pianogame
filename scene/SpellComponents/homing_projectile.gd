extends Projectile
class_name HomingProjectile
var target:Node2D
func _process(delta: float) -> void:
	if target == null:
		return super(delta)

	# Direction from projectile to target
	var desired_direction: Vector2 = global_position.direction_to(target.global_position)

	# How quickly the projectile can turn (higher = faster)
	var turn_speed := 3.0

	# Smoothly rotate current direction toward target direction
	direction = direction.slerp(desired_direction, turn_speed * delta).normalized()
	super(delta)
