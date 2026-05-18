extends Spell

func on_trigger():
	player.velocity.y=-player.jumping_speed
	super()
	pass
