extends Enemy
@onready var projectile_2=$Projectile2
func _ready() -> void:
	remove_child(projectile_2)
	super()
	
@export var anim:AnimatedSprite2D
@export var healtbar:ProgressBar

func _on_animated_sprite_2d_frame_changed() -> void:
	match anim.animation:
		"attack_2":handle_attack_2()
		"attack_3":handle_attack_3()
		
	pass # Replace with function body.
func handle_attack_2():
	match anim.frame:
		2:anim.pause();get_tree().create_timer(0.45).timeout.connect(func():anim.play();anim.modulate=Color.WHITE;shoot_projectile($shoot_positions_2/Node2D);shoot_projectile($shoot_positions_2/Node2D2));anim.modulate=Color.RED
	pass
func _on_node_2d_hp_changed() -> void:
	healtbar.max_value=max_hp
	healtbar.value=hp
	var t=1
	var color=remap(hp,0,max_hp,0,t)
	healtbar.self_modulate=Color(t-color,color,0,t)
	pass # Replace with function body.
func _on_animated_sprite_2d_animation_finished() -> void:
	match anim.animation:
		"die":queue_free()
	pass	
func hit(damage,c):
	super(damage,c)
	_on_node_2d_hp_changed()	
func die():
	anim.play("die")	
	super()
func connect_action():
	pass
func shoot_projectile(origin):
	var pro:RigidBody2D=projectile_2.duplicate()
	
	add_sibling(pro)
	pro.position=Vector2.ZERO
	pro.global_position=origin.global_position
	
	pro.show()
	var shoot_strength=350+randf_range(-150,150)
	pro.apply_impulse((Vector2.LEFT+Vector2.UP)*shoot_strength)
	pass
func squish():
	pass	
func handle_attack_3():
	match anim.frame:
		2:shoot(Vector2.LEFT,$shoot_positions_3/Node2D.global_position);shoot(Vector2.LEFT,$shoot_positions_3/Node2D2.global_position)
	pass	


func _on_hp_changed() -> void:
	pass # Replace with function body.
