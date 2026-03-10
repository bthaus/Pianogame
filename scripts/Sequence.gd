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


func unhighlight():
	var trav_node=first_node
	cancelled.emit()
	while true:
		trav_node.hits-=1
		if trav_node.outgoing_edge!=null:
			trav_node=trav_node.outgoing_edge.to_node
		else:
			return
	pass

func traverse(active_keys: Array[String],beat):
	if done:return
	
	var next_keys=current_node.outgoing_edge.keys
	var errors=util.get_difference(active_keys,next_keys).size()
	
	error_count+=errors
	if util.is_partial_sum(active_keys,next_keys):
		current_node=current_node.outgoing_edge.to_node
		progressed=true
		notation+=util.strarr_to_string(next_keys)+" "
		print("traversed! current = "+notation)
		traversed.emit(current_node)
		current_node.hits+=1
		if current_node.activating:
			print("spell "+ current_node.spell+" activated!")
			print("errors: "+str(error_count))
			done=true
			finished.emit()
	var relative_beat=beat-start_beat
	var beat_diff=abs(current_node.beat-relative_beat)
	error_count+=beat_diff
	return done		
	pass
