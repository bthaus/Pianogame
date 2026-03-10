@tool
extends Node2D
class_name SpellFactory

	
	

static var instance:SpellFactory:
	get():
		if instance==null:
			instance=load("res://Scenes/spell_factory.tscn").instantiate()
		return instance	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func get_spell(spellname):
	return instance.find_child(spellname).duplicate()
	
	
static func get_all_spells():
	var retarr=[] as Array[Spell]
	for spell in instance.get_children():
		retarr.append(spell.duplicate())
	return retarr	
	pass	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if Engine.is_editor_hint():
		_tool_process(delta)
	pass

func _tool_process(delta:float)->void:
	
	pass
