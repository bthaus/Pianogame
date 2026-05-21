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
var allow_input_always=true
var input_history:Set=Set.new()
var error_count=0
var player:PlayerCharacter
var easy_move=true
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
	
func _ready() -> void:
	for s:Spell in equipped_spells:
		add_spell_visual(s)
	var off=0	
	for s:SequenceTreeVisual in $trees.get_children():
		s.translate(Vector2(off,0))
		var addoff=s.tree.get_last_node().beat*50
		off+=150+addoff
	
	pass
func add_spell_visual(spell):
	var visual=load('res://Scenes/note_visual.tscn').instantiate()
	$trees.add_child(visual)
	visual.set_up(spell)
	
	print("visual set up")
	
	pass;	
func add_spell(spell:Spell):
	equipped_spells.append(spell)
	add_child(spell)
	spell.setup()
	pass	
var last_movement_event:PianoEvent	
func handle_movement(event:PianoEvent):
	player.highlight_move_key(event.get_key())
	if event.get_key()=="G2":
		player.jump()
		return
	if last_movement_event==null:
		last_movement_event=event
		return
	if event.timestamp-last_movement_event.timestamp>1000:
		last_movement_event=event
		return
	var diff=movement_keys.find(last_movement_event.get_key())-movement_keys.find(event.get_key())
	
	if [-1,1,3,-3].has(diff):
		if !(last_movement_event.get_key()=="C2" and event.get_key()=="F2") and event.midi_event.pitch>last_movement_event.midi_event.pitch or (last_movement_event.get_key()=="F2" and event.get_key()=="C2"):
			player.move(Vector2.RIGHT,event.get_key())
		if !(last_movement_event.get_key()=="F2" and event.get_key()=="C2") and event.midi_event.pitch<last_movement_event.midi_event.pitch or (last_movement_event.get_key()=="C2" and event.get_key()=="F2"):
			player.move(Vector2.LEFT,event.get_key())	
			
	last_movement_event=event	
	pass;
var movement_pointer=0:
	set(val):
		if val>=movement_keys.size():
			val=0
		if val<0:
			val=movement_keys.size()-1
		movement_pointer=val				
var movement_keys=[
	"C2","D2","E2","F2"
]	
func handle_easy_movement(event:PianoEvent):
	var direction=0
	if keyController.active_keys.has("C2"):
		direction+=-1
	if keyController.active_keys.has("E2"):
		direction+=1
	if event.get_key()=="D2":
		player.jump()
	player.easy_move(direction)			
	pass
var easy_move_keys=["C2","D2","E2"]
func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	if not easy_move and movement_keys.has(piano_event.get_key()) or piano_event.get_key()=="G2":
		handle_movement(piano_event)
	if easy_move and easy_move_keys.has(piano_event.get_key()):
		handle_easy_movement(piano_event)
	input_history.add(piano_event)
	piano_event.error_detected.connect(remove_event_from_history.bind(piano_event))
	piano_event.success_detected.connect(remove_event_from_history.bind(piano_event))
	_add_key_representation(piano_event)
	input_happened=true
	input_handled=false
	
	
func handle_input():
	traverse_sequences()
	check_inputs()
	
	var rem=[]
	for key:String in keyController.active_keys.keys():
		if key.contains("UP"):rem.append(key)
	for r in rem:
		keyController.active_keys.erase(r)	
	
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
	#if  window_open or allow_input_always:
	if true:
		for spell:Spell in equipped_spells:
			var maybe_seq=spell.check_start(keys.keys(),beat.beat_no)	
			if maybe_seq!=null:
				sequences.append(maybe_seq)
				maybe_seq.remove.connect(func():sequences.erase(maybe_seq))
			

	for sequence:Sequence in sequences:
		sequence.traverse(keys,beat.beat_no)
			
				
	pass # Replace with function body.
	
	
	
func timeout_sequences():
	for s:Sequence in sequences:
		if s.is_timeout(beat.beat_no):
			s.done=true
			remove.append(s)
			l.d("removed "+s.spell.spell_name)

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
	piano_event.representation = label
	

func _on_key_controller_before_key_released(piano_event: PianoEvent) -> void:
	piano_event.press_event.representation.queue_free()
	pass # Replace with function body.


func _on_beat_close_window() -> void:
	window_open=false
	timeout_sequences()
	
	pass # Replace with function body.


func _on_beat_open_window() -> void:
	window_open=true
	#for s in sequences:
		#s.progressed=false

	pass # Replace with function body.


func _on_key_controller_key_released(piano_event: PianoEvent) -> void:
	if easy_move and easy_move_keys.has(piano_event.get_key()) and not piano_event.get_key()=="D2":
		handle_easy_movement(piano_event)
	input_happened=true
	input_handled=false
	pass # Replace with function body.
