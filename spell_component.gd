extends Node2D
class_name SpellComponent
func set_up(spell:Spell):
	
	pass
func trigger(spell:Spell,error_count):

	pass
	
func on_spell_cancelled():
	
	pass;

func on_spell_finished():
	
	pass;
	
func on_spell_started():
	pass;

func on_previous_node_traversed():
	pass

func get_beat_adherance():
	return Beat.get_beat_adherance()
	
