@tool
extends Node
class_name Spell


enum SpellType{Attack, Buff, Defense, Movement}
enum State{Cooldown,Ready,Firing}
enum SpellUnit{Nothing,CascadeBolt,CascadeStart}
var state:State=State.Ready
@export var spell_name:String
@export var spell_type:SpellType
@export var keys:Array[KeyUnit]=[]
@export var cooldown_in_beats:float
@export var keys_as_string:String=""
@export var input_line:String

static var accuracy_history:Dictionary={}

@export var beats:float=0
@export_tool_button("set_beats") var set_beats_button=set_beats
@export_tool_button("play_spell") var play=play_spell

@export var component_for_all:PackedScene
@export_tool_button("set_components") var set_comp_button=set_comps


@export_tool_button("remove all units") var remove=remove_all_units
@export var _disabled=false
var tree:Sequence_Tree
var player:PlayerCharacter
signal cooldown_passed
signal triggered
signal spell_started
signal spell_failure_or_success
func set_beats():
	var off=0
	for k:KeyUnit in keys:
		k.beat=off
		off+=beats
	pass
func set_comps():
	for k:KeyUnit in keys:
		k.spell_component=component_for_all
	pass;	
func remove_all_units():
	keys.clear()
	
var is_active=false
func check_start(active_keys,beat_no):
	if state!=State.Ready:return
	if is_active:return
	if util.is_partial_sum(active_keys, tree.entry_edge.keys):
		var started_sequence=tree.get_start_sequence(beat_no)
		started_sequence.finished.connect(trigger_spell)
		started_sequence.cancelled.connect(on_cancel)
		started_sequence.traversed.connect(on_key_played)
		started_sequence.spell=self
		started_sequence.start_beat=beat_no
		spell_started.emit()
		is_active=true
		started_sequence.finished.connect(on_failure_or_success)
		started_sequence.cancelled.connect(on_failure_or_success)
		return started_sequence
	pass;
func on_failure_or_success():
	is_active=false
	spell_failure_or_success.emit()
	pass
func setup():
	tree=parse_spell_into_sequencetree()
	if not accuracy_history.has(spell_name):accuracy_history[spell_name]=[]
	if not upgrade_values.has(spell_name):upgrade_values[spell_name]=[2,15,25,40]
	if not Sequence.beat_adherance.has(spell_name):Sequence.beat_adherance[spell_name]=[]
	prepare_spell()
	pass;
func prepare_spell():
	l.e(str(keys.size()))
	for k:KeyUnit in keys:
		k.set_up(self)
	pass	

func play_spell():
	for key:KeyUnit in keys:
		for note:String in key.key:
			var bpm=Beat.get_beat_instance().bpm
			var time_Factor=60/bpm
			var timeout=time_Factor*key.beat
			player.get_tree().create_timer(timeout).timeout.connect(play_note.bind(note))
			
	pass
func play_note(note):
	var lower_case=note.to_lower()+".mp3"
	lower_case.replace("#","-")
	var audio_player=AudioStreamPlayer.new()
	player.add_child(audio_player)
	audio_player.stream=load("res://Assets/mp3 Notes/"+lower_case)
	audio_player.play()
	audio_player.finished.connect(func():audio_player.queue_free())
	pass;	
static var upgrade_values:Dictionary
var accuracy_threshold=0.5
func add_accuracy_to_history(val):
	accuracy_history[spell_name].push_back(
		{"val"=val,
				"hp"=player.hp,
				"enemies"=Enemy.num_alive,
				"time"=Time.get_ticks_msec()}
				)
		
	
	var last_corrects=get_number_of_correct_last_spells()
	if last_corrects>upgrade_values[spell_name].front():
		upgrade_spell()		
	pass
func get_number_of_correct_last_spells():
	var count=0
	if not accuracy_history.has(spell_name):return
	for i in range(accuracy_history[spell_name].size()-1,0,-1):
		count+=1
		if accuracy_history[spell_name][i]["val"]>accuracy_threshold:break
	return count
	pass	
func upgrade_spell():
	upgrade_values[spell_name].pop_front()
	
	player.level_up()
	for key:KeyUnit in keys:
		if key.get_spell_component()!=null:
			key.get_spell_component().upgrade_spell_component()
	pass	
	
func trigger_spell():
	if state!=State.Ready:return
	
	
	on_trigger()
	start_cooldown()
	triggered.emit()
	pass;
func trigger_node(node:SequenceNode,error_count):
	node.key_unit.trigger_spell_component(node,self,error_count)
	pass;
var cooldown_timer:SceneTreeTimer	
func start_cooldown():
	if cooldown_in_beats==0:return
	state=State.Cooldown
	cooldown_timer=get_tree().create_timer(util.seconds_from_beats_and_bpm(cooldown_in_beats,Global.bpm))
	cooldown_timer.timeout.connect(on_cooldown_passed)
	pass
	
func on_first_key_played():
	pass;

func on_key_played(sequence_node):
	pass;
func on_first_key_last_unit_lifted():
	
	pass;
func on_all_last_keys_lifted():
	
	pass;	
func on_trigger():
	
	pass;

func on_cooldown_passed():
	state=State.Ready
	cooldown_passed.emit()
	pass;	

func on_perfect_play():
	pass;
func on_cancel():
	l.e("CANCELLED")
	pass;
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_tool_process(delta)
	pass



func parse_spell_into_sequencetree():
	tree = Sequence_Tree.new()
	var key_array=keys.duplicate()
	
	var first=key_array.pop_front()
	tree.entry_edge = SequenceEdge.new(first.key)
	var current_node = SequenceNode.new()
	current_node.beat=first.beat
	var current_edge = tree.entry_edge
	current_node.incoming_edge = current_edge
	current_edge.to_node = current_node
	current_node.info_dic=first
	current_node.key_unit=first
	while not key_array.is_empty():
		var current_note=key_array.pop_front() 
		current_edge = SequenceEdge.new(current_note.key)
		current_node.outgoing_edge=current_edge
		current_node = SequenceNode.new()
		current_node.info_dic=current_note
		current_node.incoming_edge = current_edge
		current_edge.to_node = current_node
		current_node.beat=current_note.beat
		current_node.key_unit=current_note
		
	current_node.activating = true
	
	return tree	


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
