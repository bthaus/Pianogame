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
@export var store_keys:Array[KeyUnit]
static var accuracy_history:Dictionary={}

@export var beats:float=0
@export_tool_button("set_beats") var set_beats_button=set_beats
@export_tool_button("play_spell") var play=play_spell

@export var component_for_all:PackedScene
@export_tool_button("set_components") var set_comp_button=set_comps
@export var timing_factor:float=1

@export_tool_button("remove all units") var remove=remove_all_units
@export var _disabled=false
@export var error_factor:float=1.0

@export var full_input:String=""
@export_tool_button("parse full input") var parse=parse_input
var tree:Sequence_Tree
var player:PlayerCharacter
signal cooldown_passed
signal triggered
signal spell_started
signal spell_failure_or_success

func parse_input():
	var cleanaed=full_input.replace("\n","")
	var keyunits=cleanaed.split("-")
	var units=[]
	for k in keyunits:
		var temp=k.split("+")
		if temp.size()<2:continue
		print(temp)
		units.push_back({"time":temp[0],"key":temp[1]})
	var beat_time=60.0/90.0
	beat_time*=1000
	keys.clear()
	var last_stamp=0
	var last_keys=[]
	for entry in units:
		var beat=entry["time"].to_float()
		var key=entry["key"]
		if beat-last_stamp<50:
			last_keys.append(key)
			last_stamp=beat
			continue
		elif not last_keys.is_empty():
			var unit=KeyUnit.new()
			unit.beat=last_stamp/beat_time
			unit.key.append_array(last_keys)
			keys.push_back(unit)
			last_keys.clear()
			
		
		var unit=KeyUnit.new()
		unit.beat=beat/beat_time
		unit.key.append(key)
		keys.push_back(unit)
	
	pass

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
var current_sequence:Sequence	
var is_active=false
func check_start(active_keys,beat_no):
	if state!=State.Ready:return
	if tree.entry_edge.can_traverse(active_keys):
	#if util.is_partial_sum(active_keys, tree.entry_edge.keys):
		if is_active:
			current_sequence.cancel()
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
		started_sequence.finished.connect(started_sequence.check_off_time)
		spell_failure_or_success.connect(func():
			if is_instance_valid(started_sequence):
				started_sequence.queue_free()
			)
		current_sequence=started_sequence
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

func play_spell(speed):
	player.hud.toggle_piano(true)
	
	for key:KeyUnit in keys:
		for note:String in key.key:
			var bpm=Beat.get_beat_instance().bpm
			var time_Factor=60/bpm*speed
			var timeout=time_Factor*key.beat
			var last=false
			last=keys.back()==key and key.key.back()==note
			var visual=SequenceTreeVisual.visual_dic[key]
			player.get_tree().create_timer(timeout).timeout.connect(play_note.bind(note,visual,last))
					
	pass
func play_note(note,unit:SequenceNodeVisual,last):
	
	#var visual:SequenceTreeVisual=player.piano.get_spell_visual(spell_name)
	unit.highlight()
	player.hud.visual_piano.toggle_key(PianoEvent.pitches[note],true,true)
	var lower_case=note.to_lower()+".mp3"
	lower_case=lower_case.replace("#","-")
	var audio_player=AudioStreamPlayer.new()
	player.add_child(audio_player)
	audio_player.volume_db=-80
	audio_player.stream=load("res://Assets/mp3 Notes/"+lower_case)
	audio_player.play(0.03)
	audio_player.finished.connect(func():
		unit.unhighlight()
		if last:player.hud.toggle_piano(false)
			
		player.hud.visual_piano.toggle_key(PianoEvent.pitches[note],false,false)
		audio_player.queue_free())
	pass;	
static var upgrade_values:Dictionary
var accuracy_threshold=0.5
func add_accuracy_to_history(val):
	if !accuracy_history.has(spell_name):accuracy_history[spell_name]=[]
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
	node.key_unit.trigger_spell_component(node,self,error_count*error_factor)
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
	var index=1
	var first=key_array.pop_front()
	tree.entry_edge = SequenceEdge.new(first.key)
	var current_node = SequenceNode.new()
	current_node.node_nr=index
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
		index+=1
		current_node.node_nr=index
		
		current_node.info_dic=current_note
		current_node.incoming_edge = current_edge
		current_edge.to_node = current_node
		current_node.beat=current_note.beat*timing_factor
		current_node.key_unit=current_note
		
	current_node.activating = true
	
	return tree	


func _tool_process(delta:float)->void:
	
	if input_line.contains(" "):
		var u=KeyUnit.new()
		var arr:PackedStringArray=input_line.remove_char(32).split("+") 
		var k:Array[String]=Array(Array(arr),TYPE_STRING,"",null)
		
		u.key=k
		u.beat=keys.size()
		input_line=""
		keys.push_back(u)
		
	keys_as_string=""
	for a:KeyUnit in keys:
		keys_as_string+=util.strarr_to_string(a.key)+" "
		
	name=spell_name		
	pass;	
