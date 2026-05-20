extends Node
class_name Sequence_Tree
var entry_edge: SequenceEdge
var start_node=SequenceNode.new()
#@export var nodes: Array[SequenceNode] = []

func get_start_sequence(beatno:float)->Sequence:
	var started_sequence=Sequence.new()
	started_sequence.start_beat=beatno
	started_sequence.first_node=start_node
	started_sequence.current_node=start_node
	start_node.outgoing_edge=entry_edge
	started_sequence.error_count=0
	return started_sequence

func traverse_tree(keys):
	pass
func get_last_node():
	var node=entry_edge.to_node
	while node.outgoing_edge!=null:
		node=node.outgoing_edge.to_node
	return node	
	
