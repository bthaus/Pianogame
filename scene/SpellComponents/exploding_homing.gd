extends HomingProjectile

var explosion_damage=100
func collide():
	Explosion.start(global_position,get_tree(),explosion_damage,error_count)
	super()
