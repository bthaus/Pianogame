extends Node2D
class_name Piano

@onready var keyController: KeyController = $KeyController

var sequence_trees:Array[Sequence_Tree]=[]
var sequences:Array[Sequence]
var frame_checked = false
var hit_low=0
var hit_high=0
var accuracy=50
var window_open=false
func _ready() -> void:
	var parser=SpellParser.new()
	sequence_trees.append(parser.parse_spell_into_sequencetree(parser.example_spell))
	sequence_trees.append(parser.parse_spell_into_sequencetree(parser.exs_2))
	pass
func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:

	_add_key_representation(piano_event)
	if  window_open:
		print("missclick!")
		return
	
	traverse_sequences()
	
var remove=[]	
func traverse_sequences():
	
	var keys=keyController.active_keys.keys()
	for tree:Sequence_Tree in sequence_trees:
		if util.is_partial_sum(tree.entry_edge.keys,keys):
			var started_sequence=tree.get_start_sequence()
			sequences.append(started_sequence)
	for sequence:Sequence in sequences:
		if sequence.traverse(keys):
			remove.append(sequence)
				
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	frame_checked = false
	
func timeout_sequences():
	for s in sequences:
		if not s.progressed:
			remove.append(s)
		s.progressed=false	
		
	for r in remove:
		sequences.erase(r)	
	remove.clear()	
func check_spells():
	if frame_checked: return
	frame_checked = true
	
func _add_key_representation(piano_event: PianoEvent):
	var label = Label.new()
	label.text = piano_event.get_key()
	label.name = piano_event.get_key()
	$PressedKeys.add_child(label)
	piano_event.representation = label
	

func _on_key_controller_before_key_released(piano_event: PianoEvent) -> void:
	piano_event.press_event.representation.queue_free()
	pass # Replace with function body.


func _on_beat_beat() -> void:
	var time=Time.get_ticks_msec()
	
	pass # Replace with function body.


func _on_beat_close_window() -> void:
	window_open=false
	timeout_sequences()
	$window.text="c"
	pass # Replace with function body.


func _on_beat_open_window() -> void:
	window_open=true
	$window.text="0000000"
	pass # Replace with function body.
