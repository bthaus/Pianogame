extends SpellComponent
var shield_hp=20
var shield_active=false
func trigger(spell:Spell,error_count):
	if shield_active:return
	var s=$shield.duplicate()
	s.show()
	s.scale*=(1-error_count)
	s.hp=shield_hp*(1-error_count)
	spell.player.add_child(s)
	l.e(str(error_count))
	s.global_position=spell.player.shield_pos.global_position	
	s.destroyed.connect(destroyed)
	shield_active=true
	super(spell,error_count)
	pass

func destroyed():
	shield_active=false
	pass	
