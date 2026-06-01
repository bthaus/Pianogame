extends Character
class_name PlayerCharacter
@export var piano:Piano
@export var hud:HUD
@onready var enemy_scanner:EnemyScanner=$Enemy_Scanner
@export var movement_locked=false
var easy_move_direction=0	
static var spawnpoint:Vector2=Vector2.ZERO
@export var acceleration := 1200.0
@export var friction := 1000.0	
var spells
var walking=false
var on_color=Color(1.0, 0.0, 0.0, 1.0)
var off_color=Color(1.0, 1.0, 1.0, 1.0)
var heals=5:
	set(value):
		heals=clamp(value,0,5)
		hud.update()
var since_last=0
func jump():
	if movement_locked:return
	super()
func increase_max_health():
	level_up()
	max_hp+=25
	hp+=25
	pass
func _physics_process(delta: float) -> void:
	super(delta)
	if movement_locked:velocity=Vector2.ZERO
func _process(delta: float) -> void:
	since_last+=delta
	if since_last>1:
		highlight_move_key("none")
	if Input.is_action_just_pressed(&'C'):
		var casc:Spell=piano.get_spell_instance("cascade")
		casc.play_spell()
		#for spell in SpellFactory.get_all_spells():
			#unlock(spell)
		#DataStorer.save_player_data(self)	
	pass
	
func unlock(spell_name,learn=true):
	if learned_spells.has(spell_name) and learn:return
	var spell=SpellFactory.get_spell(spell_name)
	piano.add_spell(spell)
	if learn:learned_spells.append(spell_name)
	return spell
	
func highlight_move_key(key:String):
	
	$F.color=off_color
	$G.color=off_color
	$A.color=off_color
	$B.color=off_color
	$C.color=off_color
	
	if key.contains("F"):$F.color=on_color
	if key.contains("G"):$G.color=on_color
	if key.contains("A"):$A.color=on_color
	if key.contains("B"):$B.color=on_color
	if key.contains("C"):$C.color=on_color
	since_last=0
	pass
func _ready() -> void:
	if movement_locked:$base_defense_cam.make_current()
	global_position=spawnpoint
	piano=hud.piano
	if piano.easy_move:movement_speed/=2
	piano.player=self
	call_deferred("add_learned_spells")
	
	super()
func load_data():
	var data=DataStorer.get_last_data()
	if data==null:return
	var accuracy:Dictionary=data["accuracy_histories"]
	Spell.accuracy_history=accuracy
	#for spell in learned_spells:
		#var arr=accuracy[spell]
		#var spell_instance=piano.get_spell_instance(spell)
		#spell_instance.accuracy_history=arr
	var misses=data["total_missclicks"]
	Piano.total_errors=misses
	pass	
func add_learned_spells():
	if movement_locked:
		for spell in SpellFactory.get_all_spells():
			if not add_spells_override.has(spell):add_spells_override.append(spell)
	for s in add_spells_override:
		if not learned_spells.has(s):learned_spells.append(s)
	for s in learned_spells:
		piano.add_spell(SpellFactory.get_spell(s))
	load_data()		
	pass;	
func determine_x_velocity(delta):
	if movement_locked:return
	# Target horizontal speed
	if not walking:super(delta)
	var target_speed = easy_move_direction * movement_speed
	
	# Smooth acceleration / deceleration
	if easy_move_direction != 0:
		velocity.x = move_toward(
			velocity.x,
			target_speed,
			acceleration * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			friction * delta
		)
	pass
	
var deflecting=false	
var deflect_spell:DeflectSpell
func hit(damage):
	
	if deflecting:
		deflect_spell.successful_deflect()
		l.d("deflect successfull")
		return
	super(damage)
	pass	
func add_gravity(delta):
	#if not walking:return super(delta/2)
	#super(delta)
	super(delta)
	if not walking:
		velocity.y=clamp(velocity.y,-150,400)
	pass	
func level_up():
	$level_up.emitting=true
	pass	
func heal(valu):
	hp+=valu
	var tw=create_tween()
	tw.tween_property($AnimatedSprite2D, "self_modulate", Color(0,1,0,1), .25)
	tw.tween_property($AnimatedSprite2D, "self_modulate", Color(1,1,1,1), .25)
	tw.tween_property($AnimatedSprite2D, "self_modulate", Color(0,1,0,1), .25)
	tw.tween_property($AnimatedSprite2D, "self_modulate", Color(1,1,1,1), .25)
	pass	
func deflect():
	deflecting=true
	$AnimatedSprite2D.modulate=Color(100,100,100,100)
	get_tree().create_timer(0.25).timeout.connect(func():
		deflecting=false
		$AnimatedSprite2D.modulate=Color(1,1,1,1)
		)
	pass	
func move(direction,key="A1"):
	walking=false
	
	velocity.y-=100
	if velocity.y>0:velocity.y=0
	super(direction,key)
	pass	
func easy_move(direction):
	if movement_locked:return
	walking=true
	if direction!=0:face_direction=Vector2(direction,0)
	easy_move_direction=direction
	pass;	
var tree:SceneTree
func die():
	DataStorer.save_player_data(self)
	
	tree=get_tree()	
	queue_free()
	call_deferred("swap_scene")
func swap_scene():	
	tree.change_scene_to_file("res://Scenes/stats.tscn")
	
static var learned_spells=[]	
@export var add_spells_override:Array[String]=[]


func _on_groundbox_body_entered(body: Node2D) -> void:
	reset_positions()
	pass # Replace with function body.
