extends Node2D
class_name SpellComponent
var spell:Spell
func set_up(spell:Spell):
	self.spell=spell
	pass
func trigger(spell:Spell,error_count):

	pass
func upgrade_spell_component():
	
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
	
