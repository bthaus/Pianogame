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
var related_inputs=[]

func unhighlight():
	var trav_node=first_node
	
	while true:
		trav_node.hits-=1
		if trav_node.outgoing_edge!=null:
			trav_node=trav_node.outgoing_edge.to_node
		else:
			return
	pass
func cancel():
	unhighlight()
	cancelled.emit()
	pass
func traverse(key_dic,beat):
	if done:return
	var active_keys=key_dic.keys()
	var next_keys=current_node.outgoing_edge.keys
	#var errors=util.get_difference(active_keys,next_keys).size()
	#this is not neccessary anymore as input error detection has been implemented
	#error_count+=errors
	var intersec=util.get_intersection(active_keys,next_keys)
	if intersec.size()==next_keys.size():
		current_node=current_node.outgoing_edge.to_node
		progressed=true
		notation+=util.strarr_to_string(next_keys)+" "
		l.l(spell.name+"traversed! current = "+notation)
		traversed.emit(current_node)
		current_node.hits+=1
		mark_input_events(key_dic,next_keys)
		if current_node.activating:
			finish()
	var relative_beat=beat-start_beat
	var beat_diff=abs(current_node.beat-relative_beat)
	error_count+=beat_diff
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
	unhighlight()
	finished.emit()
	pass
