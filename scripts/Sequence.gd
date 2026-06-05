extends Node
class_name Sequence

var sequence_start: float # timestamp
var first_node: SequenceNode
var current_node: SequenceNode
var progressed=false
var notation=""
var done=false
var error_count=0
var off_beat_error_mod=1
var spell:Spell
var start_beat=0

signal traversed(node:SequenceNode)
signal finished
signal cancelled
signal remove
var related_inputs=[]
var last_keys_released=[]
var status:SequenceStatus=SequenceStatus.Active
enum SequenceStatus{Active,Cancelled,Success}
var beat_adherance_tolerance=0.15
var error_tracked=false
var last_progressed_beat
func check_off_time():
	
	time_diff/=current_node.node_nr
	l.d("time_diff:"+str(time_diff))
	spell.player.call_off_time(time_diff,timing)
	time_diff=0
	pass
func is_timeout(beat):
	if done: return false
	
	var current_relative_beat=beat-start_beat-current_node.beat
	var max_relative_beat=current_node.outgoing_edge.to_node.beat-current_node.beat
	var max_extra_beat=Beat.get_beat_time()
	var timeout=current_relative_beat>(max_relative_beat+max_extra_beat*2+(max_extra_beat/4*current_node.node_nr))
	if timeout:
		print("here")
	return timeout
	
	


func unhighlight():
	
	var trav_node=first_node
	
	while true:
		trav_node.hits=0
		if trav_node.outgoing_edge!=null:
			trav_node=trav_node.outgoing_edge.to_node
		else:
			return
	pass
func cancel():
	
	status=SequenceStatus.Cancelled
	unhighlight()
	cancelled.emit()
	pass
var time_diff=0	
func handle_releases(keys):
	for key:String in keys:
		if key.contains("UP"):
			key=key.replace("UP","")
			if current_node.key_unit.key.has(key):
				last_keys_released.append(key)
				if last_keys_released.size()==0:
					spell.on_first_key_last_unit_lifted()
					#l.d("first key lifted")
	if last_keys_released.size()==current_node.key_unit.key.size():
		last_keys_released.clear()
		spell.on_all_last_keys_lifted()				
		l.d("all keys lifted")	
		unhighlight()
		remove.emit()
		if current_node.outgoing_edge!=null:
			cancel()		
	pass
static var beat_adherance:Dictionary={}	
var timing
var beat_adherance_for_first_node=0:
	set(value):
		beat_adherance_for_first_node=value
		
var enemies_alive=0
var hp=0
func traverse(key_dic,beat):
	var traversed_flag=false
	if done:
		handle_releases(key_dic.keys())
		return false
	var active_keys=key_dic.keys()
	var next_keys=current_node.outgoing_edge.keys
	#var errors=util.get_difference(active_keys,next_keys).size()
	#this is not neccessary anymore as input error detection has been implemented
	#error_count+=errors
	
	if current_node.outgoing_edge.can_traverse(key_dic):	
		var _relative_beat=beat-start_beat
		var _beat_diff=current_node.outgoing_edge.to_node.beat-_relative_beat
		time_diff+=_beat_diff
		_beat_diff=abs(_beat_diff)
		#if _beat_diff>current_node.outgoing_edge.to_node.beat/2:
			#error_count+=_beat_diff
			#return
		#beat_adherance_for_first_node=0
		if is_first_node():
			timing=Beat.get_timing()
			beat_adherance_for_first_node=min(timing["from_last"],timing["to_next"])
			enemies_alive=Enemy.num_alive
			hp=spell.player.hp
			if beat_adherance_for_first_node<=beat_adherance_tolerance:
				beat_adherance_for_first_node=0
			error_count+=beat_adherance_for_first_node
		current_node=current_node.outgoing_edge.to_node
		progressed=true
		traversed_flag=true
		last_progressed_beat=beat
		notation+=util.strarr_to_string(next_keys)+" "
	
		traversed.emit(current_node)
		current_node.hits+=1
		
		
		var relative_beat=beat-start_beat
		var beat_diff=abs(current_node.beat-relative_beat)
		
		error_count+=beat_diff
		spell.trigger_node(current_node,error_count)
		mark_input_events(key_dic,next_keys)
		if current_node.outgoing_edge==null:
			spell.add_accuracy_to_history(error_count)
			if error_count<0.5:
				spell.player.heal(5)
			
			finish()
			beat_adherance[spell.spell_name].push_back(
				{"val"=beat_adherance_for_first_node,
				"hp"=hp,
				"enemies"=enemies_alive}
				)
			spell.player.piano.consecutive_spells_without_error+=1
			status=SequenceStatus.Success
	return traversed	 
	pass
func is_first_node():
	return current_node==first_node
	pass	
func mark_input_events(dic:Dictionary,keys):
	for key in keys:
		var event=dic[key]
		related_inputs.append(event)
		event.add_sequence(self)
		
	pass	
	
func finish():
	l.l("errors: "+str(error_count))
	done=true
	spell.cooldown_passed.connect(unhighlight)
	finished.emit()
	pass
