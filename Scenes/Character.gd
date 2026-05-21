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

var since_last=0
func _process(delta: float) -> void:
	since_last+=delta
	if since_last>1:
		highlight_move_key("none")
	pass
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
	spells=SpellFactory.get_all_spells()
	piano.player=self
	
	for s:Spell in spells:
		s.player=self
		s.prepare_spell()
		piano.add_spell(s)
		
	super()
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
	get_tree().reload_current_scene()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play(&'stand')
	pass # Replace with function body.
