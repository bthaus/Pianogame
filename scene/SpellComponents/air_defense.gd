extends Fireball


func get_target():
	spell.player.projectile_scanner.next_target()
	return spell.player.projectile_scanner.current_target
