extends Node2D
@export var spell_name:String


func _ready() -> void:
	if PlayerCharacter.learned_spells.has(spell_name):queue_free()
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		if spell_name=="elise":
			var all=SpellFactory.get_all_spells()
			for a in all:
				body.unlock(a)
		queue_free()
	pass # Replace with function body.
