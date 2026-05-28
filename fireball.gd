extends SpellComponent
class_name Fireball
@export var damage=10
func trigger(spell:Spell,error_count):
	var ball:HomingProjectile=$Area2D.duplicate()
	ball.damage=damage*(2-error_count)
	ball.scale*=(clamp(2-error_count,0,2))
	
	ball.global_position=spell.player.projectile_pos.global_position
	ball.direction=get_direction(spell)
	ball.target=spell.player.enemy_scanner.current_target
	ball.error_count=error_count
	spell.player.add_sibling(ball)
	spell.player.enemy_scanner.target_changed.connect(func(target:Enemy):if ball!=null:ball.target=target)
	super(spell,error_count)
	pass

func get_direction(spell:Spell):
	return spell.player.face_direction
	pass

func upgrade_spell_component():
	damage*=1.3
	pass
