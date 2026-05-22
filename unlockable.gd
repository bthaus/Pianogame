extends Node2D
@export var spell_name:String


func _ready() -> void:
	if PlayerCharacter.learned_spells.has(spell_name):queue_free()
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body.unlock(spell_name)
		queue_free()
	pass # Replace with function body.
