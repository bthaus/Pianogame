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
var ex_2={
	"name"="test",
	"keys"=[
		{"beat":1,
		"keys":["C4"]},
		
		{"beat":1.5,
		"keys":["E4"]},
		
		{"beat":2,
		"keys":[ "G4", "E4"]}
		
	]
}
var ex_3={
	"name"="schlaf",
	"keys"=[
		{"beat":0,
		"keys":["A4"]},
		
		{"beat":1,
		"keys":["G4"]},
		
		{"beat":1.5,
		"keys":[ "G4"]},
		
		{"beat":2,
		"keys":[ "F4"]}
		
	]
}
var ex_4={
	"name"="schlafchord",
	"keys"=[
		{"beat":0,
		"keys":["A4","F4","D4"]}
	]
}
var ex_5={
	"name"="pause",
	"keys"=[
		{"beat":0,
		"keys":["C5"]},
		{"beat":1,
		"keys":[]},
		{"beat":2,
		"keys":["C5"]},
	]
	
}
func _ready():
	
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
		
	current_node.activating = true
	current_node.spell=spell
	
	return tree

func parse_spelldic_into_sequencetree(dic: Dictionary):
	var tree = Sequence_Tree.new()
	var spell = dic["name"]
	var key_array=dic["keys"]
	
	var first=key_array.pop_front()
	tree.entry_edge = SequenceEdge.new(first["keys"])
	var current_node = SequenceNode.new()
	current_node.beat=first["beat"]
	var current_edge = tree.entry_edge
	current_node.incoming_edge = current_edge
	current_edge.to_node = current_node
	current_node.info_dic=first
	
	while not key_array.is_empty():
		var current_note=key_array.pop_front()
		current_edge = SequenceEdge.new(current_note["keys"])
		current_node.outgoing_edge=current_edge
		current_node = SequenceNode.new()
		current_node.info_dic=current_note
		current_node.incoming_edge = current_edge
		current_edge.to_node = current_node
		current_node.beat=current_note["beat"]
		
	current_node.activating = true
	current_node.spell=spell
	
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
