extends HomingProjectile
var scanner
func _process(delta: float) -> void:
	if not is_instance_valid(target):target=scanner.next_target()
	#if target==null:collide()
	super(delta)
func get_target_pos():
	return global_position.direction_to(target.global_position)
	
func connect_with_scanner(player:PlayerCharacter):
	scanner=player.projectile_scanner
	return
	pass
