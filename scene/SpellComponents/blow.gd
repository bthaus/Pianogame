extends SpellComponent

var scanner:Area2D
var freeze_duration=2
func trigger(spell:Spell,error_count,factor=1):
	var enemies=scanner.get_overlapping_bodies()
	
	for e:Enemy in enemies:
		freeze(e,error_count)
	pass
func freeze(e:Enemy,error_count):
	e.frozen=true
	e.get_tree().create_timer(freeze_duration-error_count).timeout.connect(func():e.frozen=false)
	pass
		
func set_up(spell:Spell):
	scanner=$Area2D.duplicate()
	$Area2D.global_position=spell.player.global_position
	scanner.reparent(spell.player)
	
	super(spell)
	pass

func upgrade_spell_component():
	freeze_duration*1.5
