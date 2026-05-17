extends Character
class_name PlayerCharacter
@export var piano:Piano
@onready var enemy_scanner:EnemyScanner=$Enemy_Scanner
		
func _ready() -> void:
	
	var spell=SpellFactory.get_all_spells()
	piano.player=self
	for s:Spell in spell:
		s.player=self
		piano.add_spell(s)
	super()
	
