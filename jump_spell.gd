extends SpellComponent

func trigger(spell:Spell,error_count,factor=1):
	spell.player.velocity.y=-spell.player.jumping_speed
	super(spell,error_count)
	pass
