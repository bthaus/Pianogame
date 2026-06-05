@tool
extends Node2D
class_name SpellFactory
@export_tool_button("activate_all") var activate_all=activate_all_spells

static var spells={}

func activate_all_spells():
	for s in get_children():
		s._disabled=false
	pass;	

static var instance:SpellFactory:
	get():
		if instance==null:
			instance=load("res://Scenes/spell_factory.tscn").instantiate()
		return instance	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
static func add_missing_stored_spells():
	var stored_spell_names=DataStorer.get_data(DataStorer.spell_name_path)
	if stored_spell_names==null:return
	for spell in stored_spell_names:
		var temp=instance.find_child(spell)
		if temp==null:
			instance.add_spell(spell)
	pass
func add_spell(spell_name):
	var spell_dic=DataStorer.get_stored_spell(spell_name)
	var spell=SpellCreator.get_spell_from_data(spell_dic["Color"],spell_dic["Data"],spell_dic["Name"])
	instance.add_child(spell)
	spells[spell_name]=spell
	pass	
static func get_spell(spellname):
	add_missing_stored_spells()
	var spell= instance.find_child(spellname.to_lower())
	if spell!=null:
		return spell.duplicate()
	var temp=spells
	spell=spells[spellname].duplicate()
	return spell	
	
	
static func get_all_spells():
	var retarr=[] 
	add_missing_stored_spells()
	for spell in instance.get_children():
		if spell._disabled:continue
		retarr.append(spell.spell_name)
	
	return retarr	
	pass	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if Engine.is_editor_hint():
		_tool_process(delta)
	pass

func _tool_process(delta:float)->void:
	
	pass
