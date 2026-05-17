extends SpellComponent
class_name Fireball
@export var damage:int
func trigger(spell:Spell):
	var ball:Projectile=$Area2D.duplicate()
	ball.damage=damage
	ball.global_position=spell.player.projectile_pos.global_position
	ball.direction=spell.player.face_direction
	spell.player.add_sibling(ball)
	super(spell)
	pass
