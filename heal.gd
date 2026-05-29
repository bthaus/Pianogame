extends SpellComponent
class_name Heal

var heal_amount=50

func trigger(spell:Spell,error_count,factor=1):
	spell.player.heals-=1
	if spell.player.heals>0:
		spell.player.hp+=heal_amount-error_count*2
	pass

func upgrade_spell_component():
	heal_amount*=1.3
	
