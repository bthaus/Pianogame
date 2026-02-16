extends Node
class_name SpellParser
var example_spell = [
	"Spellname",
	["C4"],
	["E4"],
	[ "G4", "E4"]
]
var exs_2=[
	"Accord",
	["C4","E4","G4"]
	
]
func _ready():
	print("spell parser initiated")
	var tree=parse_spell_into_sequencetree(example_spell)
	print_sequence_tree(tree)	
	pass

func parse_spell_into_sequencetree(key_array: Array):
	var tree = Sequence_Tree.new()
	var spell = key_array.pop_front()
	
	tree.entry_edge = SequenceEdge.new(key_array.pop_front())
	var current_node = SequenceNode.new()
	current_node.activating = key_array.is_empty()
	var current_edge = tree.entry_edge
	current_node.incoming_edge = current_edge
	current_edge.to_node = current_node
	
	while not key_array.is_empty():
		current_edge = SequenceEdge.new(key_array.pop_front())
		current_node.outgoing_edge=current_edge
		current_node = SequenceNode.new()
		current_node.incoming_edge = current_edge
		current_edge.to_node = current_node
		print(key_array.size())
	current_node.activating = true
	current_node.spell=spell
	print("tree done")
	return tree
	
	
func print_sequence_tree(tree:Sequence_Tree):
	print(tree.entry_edge.keys)
	var current_node=tree.entry_edge.to_node
	while not current_node.activating:
		var edge=current_node.outgoing_edge as SequenceEdge
		print(edge.keys)
		current_node=edge.to_node
	print(current_node.activating)	
	pass	
