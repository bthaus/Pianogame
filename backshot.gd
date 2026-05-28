extends Fireball
class_name Backshot


func get_direction(spell:Spell):
	if spell.player.movement_locked:return super(spell)
	return super(spell)*-1
	
