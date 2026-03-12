extends Node2D
class_name Piano

@onready var keyController: KeyController = $KeyController
@onready var beat:Beat=$Beat

var sequences:Array[Sequence]
var equipped_spells:Array[Spell]=[]
var frame_checked = false
var hit_low=0
var hit_high=0
var accuracy=50
var window_open=false

var input_history:Set=Set.new()
var error_count=0

func register_error(e:EventStatus):
	
	if e.type!=EventStatus.StatusType.Unstarted:
		if e.related_sequence.error_tracked:
			return
		e.related_sequence.error_tracked=true
	e.print_info()
	if e.type!=e.StatusType.Success:
		error_count+=1
		l.d(str(error_count))
		
	pass

var frame=0
var input_happened=false
var input_handled=false
func _process(delta: float) -> void:
	if input_happened and not input_handled:
		call_deferred("handle_input")
	frame+=1
	$frame.text=str(frame)
	var st=""
	for s:Sequence in sequences:
		st+=s.spell.name+"\n"
	$seqs.text=st	
func _ready() -> void:
	
	equipped_spells=SpellFactory.get_all_spells()
	for spell:Spell in equipped_spells:
		add_child(spell)
		spell.setup()
	var visual=SequenceTreeVisual.new()
	visual.set_up(equipped_spells[0].tree)
	$trees.add_child(visual)
	
	pass
func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	input_history.add(piano_event)
	piano_event.error_detected.connect(remove_event_from_history.bind(piano_event))
	piano_event.success_detected.connect(remove_event_from_history.bind(piano_event))
	_add_key_representation(piano_event)
	input_happened=true
	input_handled=false
	
	
func handle_input():
	traverse_sequences()
	check_inputs()
	input_happened=false
	input_handled=true
	pass;	
func remove_event_from_history(error:EventStatus,p):
	input_history.rem(p)
	if error!=null:
		register_error(error)
	pass	
func check_inputs():
	var rem=[]
	for a:PianoEvent in input_history.content:
		if a.related_sequences.is_empty():
			rem.append(a)
			
	for r:PianoEvent in rem: 
		r.error_detected.emit(EventStatus.new(EventStatus.StatusType.Unstarted,r,null))
				
	
	pass;	
	
var remove=[]



	
func traverse_sequences():
	
	var keys=keyController.active_keys
	if  window_open:
		for spell:Spell in equipped_spells:
			var maybe_seq=spell.check_start(keys.keys(),beat.beat_no)	
			if maybe_seq!=null:
				sequences.append(maybe_seq)
				maybe_seq.finished.connect(func():
					sequences.erase(maybe_seq)
					l.l(maybe_seq.spell.name+" erased")
					)
				
	for sequence:Sequence in sequences:
		sequence.traverse(keys,beat.beat_no)
			
				
	pass # Replace with function body.
	
	
	
func timeout_sequences():
	for s:Sequence in sequences:
		if s.is_progressed(beat.beat_no):
		#if not s.progressed:
			remove.append(s)

	for r:Sequence in remove:
		r.cancel()
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


func _on_beat_close_window() -> void:
	window_open=false
	timeout_sequences()
	$window.text="c"
	pass # Replace with function body.


func _on_beat_open_window() -> void:
	window_open=true
	#for s in sequences:
		#s.progressed=false
	$window.text="0000000"
	pass # Replace with function body.


func _on_key_controller_key_released(piano_event: PianoEvent) -> void:
	pass # Replace with function body.
