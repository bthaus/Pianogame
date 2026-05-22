extends SpellComponent

var scanner:Area2D

func trigger(spell:Spell,error_count):
	var enemies=scanner.get_overlapping_bodies()
	
	for e:Enemy in enemies:
		freeze(e,error_count)
	pass
func freeze(e:Enemy,error_count):
	e.frozen=true
	e.get_tree().create_timer(2-error_count).timeout.connect(func():e.frozen=false)
	pass
		
func set_up(spell:Spell):
	scanner=$Area2D.duplicate()
	$Area2D.global_position=spell.player.global_position
	scanner.reparent(spell.player)
	
	super(spell)
	pass
