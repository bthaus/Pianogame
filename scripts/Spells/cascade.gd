extends Spell
class_name Cascade

func trigger_spell():
	super()
	var casc=player.piano.get_spell_instance("casc_asc")
	if casc==null:return
	casc.charges+=1
	
