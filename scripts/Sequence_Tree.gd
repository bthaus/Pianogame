extends Node
class_name Sequence_Tree
var entry_edge: SequenceEdge
@export var nodes: Array[SequenceNode] = []

func get_start_sequence()->Sequence:
	var started_sequence=Sequence.new()
	var start_node=SequenceNode.new()
	started_sequence.current_node=start_node
	start_node.outgoing_edge=entry_edge
	return started_sequence

func traverse_tree(keys):
	pass
