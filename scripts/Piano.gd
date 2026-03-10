extends Node2D
class_name Piano

@onready var keyController: KeyController = $KeyController
@onready var beat:Beat=$Beat
var sequence_trees:Array[Sequence_Tree]=[]
var sequences:Array[Sequence]
var equipped_spells:Array[Spell]=[]
var frame_checked = false
var hit_low=0
var hit_high=0
var accuracy=50
var window_open=false

func _ready() -> void:
	
	equipped_spells=SpellFactory.get_all_spells()
	for spell:Spell in equipped_spells:
		spell.setup()
	var visual=SequenceTreeVisual.new()
	visual.set_up(equipped_spells[0].tree)
	$trees.add_child(visual)
	#sequence_trees.append(parser.parse_spell_into_sequencetree(parser.example_spell))
	#sequence_trees.append(parser.parse_spell_into_sequencetree(parser.exs_2))
	pass
func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:

	_add_key_representation(piano_event)
	
	
	traverse_sequences()
	
var remove=[]	
func traverse_sequences():
	
	var keys=keyController.active_keys.keys()
	if  window_open:
		for spell:Spell in equipped_spells:
			var maybe_seq=spell.check_start(keys,beat.beat_no)	
			if maybe_seq!=null:
				sequences.append(maybe_seq)
				
	for sequence:Sequence in sequences:
		if sequence.traverse(keys,beat.beat_no):
			remove.append(sequence)
				
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	frame_checked = false
	
func timeout_sequences():
	for s in sequences:
		if not s.progressed:
			remove.append(s)
		s.progressed=false	
		
	for r:Sequence in remove:
		r.unhighlight()
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
