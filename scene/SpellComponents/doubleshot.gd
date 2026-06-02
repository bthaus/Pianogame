extends Fireball

func trigger(spell:Spell,error_count,factor=1):
	spell.player.get_tree().create_timer(0.1).timeout.connect(shoot.bind(spell,error_count,factor))
	super(spell,error_count,factor)
	pass
