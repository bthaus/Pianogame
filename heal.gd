extends SpellComponent
class_name Heal


func trigger(spell:Spell,error_count):
	spell.player.heals-=1
	if spell.player.heals>0:
		spell.player.hp+=50-error_count*2
	pass
