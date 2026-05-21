extends Resource
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

func is_timeout(beat):
	if done: return false
	var next_beat=start_beat+current_node.outgoing_edge.to_node.beat
	var max_diff=next_beat-start_beat
	var current_diff=beat-start_beat
	var timeout= max_diff*2<current_diff
	return timeout
	#var relative_beat=beat-start_beat
	#var beat_diff=abs(current_node.beat-relative_beat)
	#var max_diff=current_node.outgoing_edge.to_node.beat-current_node.beat
	#return beat_diff>max_diff*2
	


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
	
func handle_releases(keys):
	for key:String in keys:
		if key.contains("UP"):
			key=key.replace("UP","")
			if current_node.key_unit.key.has(key):
				last_keys_released.append(key)
				if last_keys_released.size()==0:
					spell.on_first_key_last_unit_lifted()
					l.d("first key lifted")
	if last_keys_released.size()==current_node.key_unit.key.size():
		last_keys_released.clear()
		spell.on_all_last_keys_lifted()				
		l.d("all keys lifted")	
		unhighlight()
		remove.emit()
		if current_node.outgoing_edge!=null:
			cancel()		
	pass
func traverse(key_dic,beat):
	if done:
		handle_releases(key_dic.keys())
		return
	var active_keys=key_dic.keys()
	var next_keys=current_node.outgoing_edge.keys
	#var errors=util.get_difference(active_keys,next_keys).size()
	#this is not neccessary anymore as input error detection has been implemented
	#error_count+=errors
	
	if current_node.outgoing_edge.can_traverse(key_dic):	
		var _relative_beat=beat-start_beat
		var _beat_diff=abs(current_node.outgoing_edge.to_node.beat-_relative_beat)
		if _beat_diff>current_node.outgoing_edge.to_node.beat/2:
			return
		var beat_adherance_for_first_node=0
		if is_first_node():
			beat_adherance_for_first_node=Beat.get_beat_adherance()
			if beat_adherance_for_first_node<=beat_adherance_tolerance:
				beat_adherance_for_first_node=0
			error_count+=beat_adherance_for_first_node
		current_node=current_node.outgoing_edge.to_node
		progressed=true
		last_progressed_beat=beat
		notation+=util.strarr_to_string(next_keys)+" "
		l.l(spell.name+"traversed! current = "+notation)
		traversed.emit(current_node)
		current_node.hits+=1
		
		
		var relative_beat=beat-start_beat
		var beat_diff=abs(current_node.beat-relative_beat)
		
		error_count+=beat_diff
		spell.trigger_node(current_node,error_count)
		mark_input_events(key_dic,next_keys)
		if current_node.outgoing_edge==null:
			finish()
			status=SequenceStatus.Success
	
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
