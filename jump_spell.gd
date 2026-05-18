extends SpellComponent

func trigger(spell:Spell):
	spell.player.velocity.y=-spell.player.jumping_speed
	pass
