extends Spell
class_name DeflectSpell
func trigger_node(node:SequenceNode,error_count):
	player.deflect()
	super(node,error_count)
	pass
func prepare_spell():
	
	player.deflect_spell=self
	super()
	pass;
func successful_deflect():
	cooldown_timer.timeout.emit()
	
	pass;
