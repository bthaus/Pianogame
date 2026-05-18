extends Character
class_name PlayerCharacter
@export var piano:Piano
@export var hud:HUD
@onready var enemy_scanner:EnemyScanner=$Enemy_Scanner
var easy_move_direction=0	

@export var acceleration := 1200.0
@export var friction := 1000.0	
func _ready() -> void:

	piano=hud.piano
	if piano.easy_move:movement_speed/=2
	var spell=SpellFactory.get_all_spells()
	piano.player=self
	for s:Spell in spell:
		s.player=self
		piano.add_spell(s)
	super()
func determine_x_velocity(delta):
	# Target horizontal speed
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
func easy_move(direction):
	if direction!=0:face_direction=Vector2i(direction,0)
	easy_move_direction=direction
	pass;	
func die():
	get_tree().reload_current_scene()
	
