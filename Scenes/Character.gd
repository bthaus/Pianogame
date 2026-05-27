extends Character
class_name PlayerCharacter
@export var piano:Piano
@export var hud:HUD
@onready var enemy_scanner:EnemyScanner=$Enemy_Scanner
var easy_move_direction=0	

@export var acceleration := 1200.0
@export var friction := 1000.0	
var spells
var easy_on=false
var on_color=Color(1.0, 0.0, 0.0, 1.0)
var off_color=Color(1.0, 1.0, 1.0, 1.0)
var heals=5:
	set(value):
		heals=clamp(value,0,5)
		hud.update()
var since_last=0
func increase_max_health():
	max_hp+=25
	hp+=25
	pass
func _process(delta: float) -> void:
	since_last+=delta
	if since_last>1:
		highlight_move_key("none")
	pass
	
func unlock(spell_name):
	if learned_spells.has(spell_name):return
	var spell=SpellFactory.get_spell(spell_name)
	piano.add_spell(spell)
	learned_spells.append(spell_name)
	pass;	
func highlight_move_key(key:String):
	
	$C.color=off_color
	$D.color=off_color
	$E.color=off_color
	$F.color=off_color
	
	if key.contains("C"):$C.color=on_color
	if key.contains("D"):$D.color=on_color
	if key.contains("E"):$E.color=on_color
	if key.contains("F"):$F.color=on_color
	since_last=0
	pass
func _ready() -> void:
	
	piano=hud.piano
	if piano.easy_move:movement_speed/=2
	piano.player=self
	call_deferred("add_learned_spells")
	
	super()
func add_learned_spells():
	for spell in SpellFactory.get_all_spells():
		learned_spells.append(spell)
	for s in learned_spells:
		piano.add_spell(SpellFactory.get_spell(s))
		
	pass;	
func determine_x_velocity(delta):
	# Target horizontal speed
	if not easy_on:super(delta)
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
func easy_move(direction):
	easy_on=true
	if direction!=0:face_direction=Vector2(direction,0)
	easy_move_direction=direction
	pass;	
func die():
	get_tree().change_scene_to_file('res://tests/worldtest.tscn')
static var learned_spells=[]	
