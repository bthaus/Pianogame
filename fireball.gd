extends SpellComponent
class_name Fireball
@export var damage=10
func trigger(spell:Spell,error_count,factor=1):
	var ball:HomingProjectile=$Area2D.duplicate()
	#if spell.spell_name=="simple":damage*=0.7
	ball.damage=damage*factor*(2-error_count)
	ball.scale*=(clamp(2-error_count,0,2))
	
	ball.global_position=spell.player.projectile_pos.global_position
	ball.direction=get_direction(spell)
	ball.target=spell.player.enemy_scanner.current_target
	ball.error_count=error_count
	spell.player.add_sibling(ball)
	ball.connect_with_scanner(spell.player)	
	super(spell,error_count,factor)
	pass

func get_direction(spell:Spell):
	return spell.player.face_direction
	pass

func upgrade_spell_component():
	damage*=1.3
	pass
