extends Enemy
class_name Boss
@onready var projectile_2=$Projectile2
func _ready() -> void:
#	max_hp=750
	hp=750
	remove_child(projectile_2)
	super()
	
@export var anim:AnimatedSprite2D
@export var healtbar:ProgressBar
var attacks=["attack_2","attack_2","attack_2","attack_3","scream"]
func _on_animated_sprite_2d_frame_changed() -> void:
	if player==null:return
	match anim.animation:
		"attack_2":handle_attack_2()
		"attack_3":handle_attack_3()
		"scream":handle_scream()
		
	pass # Replace with function body.
func handle_scream():
	if anim.frame<9 and anim.frame >3:
		anim.modulate=Color(randf(),randf(),randf())
		scream()
			
	match anim.frame:
		5:spawn_enemy()
		7:spawn_enemy()
		9:spawn_enemy()
	pass
func scream():
	for i in range(3):
		var pitch_scale=randf()
		var audio := AudioStreamPlayer.new()
		add_child(audio)
		audio.stream = preload("res://piano_keys/A440.wav")
		audio.pitch_scale = pitch_scale
		audio.volume_db=25
		audio.play()
		#audio.finished.connect(func():audio.queue_free())
		await get_tree().create_timer(8.0).timeout
		audio.queue_free()
	pass	
func spawn_enemy():
	var e=load('res://Scenes/ghost.tscn').instantiate()
	add_sibling(e)
	e.global_position=global_position
	pass	
func handle_attack_2():
	match anim.frame:
		2:anim.pause();get_tree().create_timer(0.45).timeout.connect(func():anim.play();anim.modulate=Color.WHITE;shoot_projectile($shoot_positions_2/Node2D);shoot_projectile($shoot_positions_2/Node2D2));anim.modulate=Color.RED
	pass
func play_anims(velocity):
	return	
func move(direction,key="D2"):
	return	
func _on_node_2d_hp_changed() -> void:
	healtbar.max_value=max_hp
	healtbar.value=hp
	var t=1
	var color=remap(hp,0,max_hp,0,t)
	healtbar.self_modulate=Color(t-color,color,0,t)
	pass # Replace with function body.
func _on_animated_sprite_2d_animation_finished() -> void:
	if player==null:anim.play("stand")
	match anim.animation:
		"die":queue_free()
		"scream":anim.modulate=Color(1,1,1)
	anim.play(attacks.pick_random())	
	pass	
func hit(damage,c):
	super(damage,c)
	_on_node_2d_hp_changed()	
func die():
	anim.play("die")	
	super()
func _on_player_detection_body_entered(body: Node2D) -> void:
	anim.play(attacks.pick_random())
	super(body)	
func connect_action():
	_on_animated_sprite_2d_frame_changed()
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
		2:shoot($shoot_positions_3/Node2D.global_position);shoot($shoot_positions_3/Node2D2.global_position)
	pass	


func _on_hp_changed() -> void:
	pass # Replace with function body.
