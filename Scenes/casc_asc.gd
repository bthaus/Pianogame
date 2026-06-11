extends Spell
func trigger_spell():
	var casc=player.piano.get_spell_instance("cascade")
	if casc==null:return
	casc.charges+=1
	super()
