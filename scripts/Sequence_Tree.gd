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
	return started_sequence

func traverse_tree(keys):
	pass
