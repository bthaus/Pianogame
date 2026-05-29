extends Resource
class_name KeyUnit
@export var beat:float
@export var key:Array[String]
@export var triggering=false
@export var spell_component:PackedScene
var loaded_spell_component:SpellComponent
const factor=1		
func set_up(spell:Spell):
	
	var comp=get_spell_component()
	if comp!=null:
		comp.set_up(spell)
	pass
func get_spell_component()->SpellComponent:
	if loaded_spell_component==null and spell_component!=null and spell_component is PackedScene:
		loaded_spell_component=spell_component.instantiate()
	return loaded_spell_component
			

func trigger_spell_component(from_node:SequenceNode, spell:Spell,error_count):
	if get_spell_component()!=null:
		loaded_spell_component.trigger(spell,error_count,factor)
		return true
	return false	
	pass;
