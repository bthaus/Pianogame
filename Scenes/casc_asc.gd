extends Spell
func trigger_spell():
	super()
	var casc=player.piano.get_spell_instance("cascade")
	if casc==null:return
	casc.charges+=1
	
