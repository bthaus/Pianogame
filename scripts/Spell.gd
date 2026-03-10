@tool
extends Node
class_name Spell


enum SpellType{Attack, Buff, Defense, Movement}

@export var spell_name:String
@export var spell_type:SpellType
@export var keys:Array[KeyUnit]=[]
@export var cooldown_in_beats:float
@export var keys_as_string:String=""
@export var input_line:String
@export_tool_button("remove all units") var remove=remove_all_units
var tree:Sequence_Tree
func remove_all_units():
	keys.clear()
func check_start(active_keys,beat_no):
	if util.is_partial_sum(tree.entry_edge.keys,active_keys):
		var started_sequence=tree.get_start_sequence(beat_no)
		return started_sequence
	pass;
func parse_spell_into_sequencetree():
	tree = Sequence_Tree.new()
	var key_array=keys
	
	var first=key_array.pop_front()
	tree.entry_edge = SequenceEdge.new(first.key)
	var current_node = SequenceNode.new()
	current_node.beat=first.beat
	var current_edge = tree.entry_edge
	current_node.incoming_edge = current_edge
	current_edge.to_node = current_node
	current_node.info_dic=first
	
	while not key_array.is_empty():
		var current_note=key_array.pop_front()
		current_edge = SequenceEdge.new(current_note.key)
		current_node.outgoing_edge=current_edge
		current_node = SequenceNode.new()
		current_node.info_dic=current_note
		current_node.incoming_edge = current_edge
		current_edge.to_node = current_node
		current_node.beat=current_note.beat
		print(key_array.size())
	current_node.activating = true
	
	return tree	
func setup():
	tree=parse_spell_into_sequencetree()
	pass;
	
func trigger_spell():
	on_trigger()
	pass;
	
func on_first_key_played():
	pass;

func on_key_played():
	pass;

func on_trigger():
	
	pass;

func on_cooldown_passed():
	pass;	

func on_perfect_play():
	pass;

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_tool_process(delta)
	pass

func _tool_process(delta:float)->void:
	
	if input_line.contains(" "):
		var u=KeyUnit.new()
		var arr:PackedStringArray=input_line.remove_char(32).split("+") 
		var k:Array[String]=Array(Array(arr),TYPE_STRING,"",null)
		print(util.strarr_to_string(k))
		u.key=k
		u.beat=keys.size()
		input_line=""
		keys.push_back(u)
		
	keys_as_string=""
	for a:KeyUnit in keys:
		keys_as_string+=util.strarr_to_string(a.key)+" "
		
	name=spell_name		
	pass;	
