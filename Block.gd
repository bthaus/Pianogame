extends SpellComponent
var shield_hp=20
var shield_active=false
func trigger(spell:Spell,error_count,factor=1):
	if shield_active:return
	var s=$shield.duplicate()
	shield_active=true
	s.show()
	s.scale*=(1-error_count)
	s.hp=shield_hp*(1-error_count)+1
	spell.player.add_child(s)
	l.e(str(error_count))
	s.global_position=spell.player.shield_pos.global_position	
	s.destroyed.connect(destroyed)
	
	s.max_hp=shield_hp
	spell.player.shields.append(s)
	s.shield_hp_changed.connect(spell.player.hud.update)
	spell.player.hud.update()
	
	super(spell,error_count)
	pass

func destroyed(shield):
	shield_active=false
	spell.player.shields.erase(shield)
	pass	
