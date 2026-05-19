extends SpellComponent

var scanner:Area2D

func trigger(spell:Spell,error_count):
	var enemies=scanner.get_overlapping_bodies()
	
	for e:Enemy in enemies:
		blast_away(e,error_count)
	pass
func blast_away(e:Enemy,error_count):
	var direction=e.global_position-global_position
	e.move(direction.normalized())
	
		
func set_up(spell:Spell):
	scanner=$Area2D
	$Area2D.global_position=spell.player.global_position
	scanner.reparent(spell.player)
	
	super(spell)
	pass
