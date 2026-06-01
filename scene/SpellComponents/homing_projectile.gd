extends Projectile
class_name HomingProjectile
var target:Enemy
func _process(delta: float) -> void:
	if target == null:
		return super(delta)
	
	# Direction from projectile to target
	var desired_direction: Vector2 = global_position.direction_to(target.center.global_position)

	# How quickly the projectile can turn (higher = faster)
	var turn_speed := 3.0

	# Smoothly rotate current direction toward target direction
	direction = direction.slerp(desired_direction, turn_speed * delta).normalized()
	super(delta)

func connect_with_scanner(player:PlayerCharacter):
	player.enemy_scanner.target_changed.connect(func(t):
		target=t)
	
	pass	
