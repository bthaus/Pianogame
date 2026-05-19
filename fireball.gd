extends SpellComponent
class_name Fireball
@export var damage=10
func trigger(spell:Spell,error_count):
	var ball:HomingProjectile=$Area2D.duplicate()
	ball.damage=damage*(2-error_count)
	ball.scale*=(2-error_count)
	ball.global_position=spell.player.projectile_pos.global_position
	ball.direction=spell.player.face_direction
	ball.target=spell.player.enemy_scanner.current_target
	spell.player.add_sibling(ball)
	spell.player.enemy_scanner.target_changed.connect(func(target:Enemy):if ball!=null:ball.target=target)
	super(spell,error_count)
	pass
