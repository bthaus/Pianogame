extends Resource
class_name KeyUnit
@export var beat:float
@export var key:Array[String]
@export var triggering=false
@export var spell_component:PackedScene
var loaded_spell_component:SpellComponent
		
		
func get_spell_component()->SpellComponent:
	if loaded_spell_component==null and spell_component!=null and spell_component is PackedScene:
		loaded_spell_component=spell_component.instantiate()
	return loaded_spell_component
			

func trigger_spell_component(from_node:SequenceNode, spell:Spell):
	if get_spell_component()!=null:
		loaded_spell_component.trigger(spell)
	pass;
