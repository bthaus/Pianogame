extends Node2D
class_name Piano

@onready var keyController: KeyController = $KeyController
@onready var beat:Beat=$Beat

var sequences:Array
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
static var easy_move=true
var upgrade_values=[5,15,25,40]
static var piano_instance=null
static func get_piano()->Piano:
	return piano_instance
	
static var total_errors=[]
var consecutive_spells_without_error=0:
	set(value):
		consecutive_spells_without_error=value
		if consecutive_spells_without_error==upgrade_values.front():
			player.increase_max_health()
			upgrade_values.pop_front()
		pass
var number_of_errors_unstarted=0:
	set(value):
		if not player:return
		if number_of_errors_unstarted<value:
			consecutive_spells_without_error=0
			total_errors.push_back({"value"=1,"hp"=player.hp,"enemies"=Enemy.num_alive,"time"=Time.get_ticks_msec()})
		number_of_errors_unstarted=clamp(value,0,5)
		player.hud.update()
		#if number_of_errors_unstarted>=5:hit_player()

func get_spell_instance(spell_name):
	for spell:Spell in equipped_spells:
		if spell.spell_name==spell_name:return spell
	pass		
func register_error(e:EventStatus):
	if e.type==EventStatus.StatusType.Unstarted:
		number_of_errors_unstarted+=1
		
	if e.type!=EventStatus.StatusType.Unstarted:
		
		if e.related_sequence.error_tracked:
			return
		e.related_sequence.error_tracked=true
	e.print_info()
	if e.type!=e.StatusType.Success:
		error_count+=1
		
		
	pass

var frame=0
var input_happened=false
var input_handled=false
func _process(delta: float) -> void:
	if input_happened and not input_handled:
		call_deferred("handle_input")
	show()
	for c in $history.get_children():
		c.queue_free()
	for a:PianoEvent in input_history.content:
		if a.related_sequences.content.is_empty():
			a.checked_frames+=delta
			if a.checked_frames>=0.1 and not a.error_played:
				$error.play()
				#remove.append(a)
				a.error_played=true
		var l=Label.new()
		l.text=a.get_key()+" "+str(a.related_sequences.content.size())
		l.label_settings=LabelSettings.new()
		l.label_settings.font_size=45
		l.label_settings.font_color=Color(0.0, 0.0, 0.0, 1.0)
		$history.add_child(l)	
	
func _ready() -> void:
	piano_instance=self
	for s:Spell in equipped_spells:
		add_spell_visual(s)

	pass
var visuals=[]	
func add_spell_visual(spell):
	var visual=load('res://Scenes/note_visual.tscn').instantiate()
	visual.spell=spell
	$trees.add_child(visual)
	visual.set_up(spell)
	visuals.append(visual)
	
	var off=0	
	for s:SequenceTreeVisual in $trees.get_children():
		s.position=Vector2(off,0)
		var addoff=s.tree.get_last_node().beat*50
		off+=150+addoff
	
	pass;	
func add_spell(spell:Spell):
	spell.player=player
	equipped_spells.append(spell)
	add_child(spell)
	spell.setup()
	add_spell_visual(spell)
	
	pass	
func get_spell_visual(spell_name):
	for visual:SequenceTreeVisual in visuals:
		if visual.spell.spell_name==spell_name:
			return visual
	pass	
var last_movement_event:PianoEvent	
func handle_movement(event:PianoEvent):
	player.highlight_move_key(event.get_key())

	if last_movement_event==null:
		last_movement_event=event
		player.reset_positions()
		return
	if event.timestamp-last_movement_event.timestamp>1000:
		player.reset_positions()
		last_movement_event=event
		return
	var diff=movement_keys.find(last_movement_event.get_key())-movement_keys.find(event.get_key())
	
	if [-1,1,4,-4].has(diff):
		if !(last_movement_event.get_key()=="F2" and event.get_key()=="C3") and event.midi_event.pitch>last_movement_event.midi_event.pitch or (last_movement_event.get_key()=="C3" and event.get_key()=="F2"):
			player.move(Vector2.RIGHT,event.get_key())
		if !(last_movement_event.get_key()=="C3" and event.get_key()=="F2") and event.midi_event.pitch<last_movement_event.midi_event.pitch or (last_movement_event.get_key()=="F2" and event.get_key()=="C1"):
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
func remove_spell(spell_name):
	var spell=get_spell_instance(spell_name)
	equipped_spells.erase(spell)
	var  visual=get_spell_visual(spell_name)
	visuals.erase(visual)
	visual.queue_free()
	pass	
func handle_easy_movement(event:PianoEvent,up=false):
	var direction=0
	if keyController.active_keys.has("F#2"):
		direction+=-1
	if keyController.active_keys.has("A#2"):
		direction+=1
	if event.get_key()=="G#2" and not up:
		player.jump()
	player.easy_move(direction)			
	pass
static var movement_keys=[
	"F2","G2","A2","B2","C3"
]	
static var easy_move_keys=["F#2","G#2","A#2"]
static var quick_menu_keys=["C#2","D#2"]
static var menu_keys=["E2","D2"]
var quick_menu_index=0:
	set(val):
		quick_menu_index=val
		if quick_menu_index>=visuals.size():quick_menu_index=0
		if quick_menu_index<0:quick_menu_index=visuals.size()-1
		pass
func handle_quick_menu(direction):
	if visuals.is_empty():return	
	visuals[quick_menu_index].unhighlight()
	quick_menu_index+=direction
	visuals[quick_menu_index].highlight()
	pass
func	 play_sound(speed):
	if visuals.is_empty():return	
	visuals[quick_menu_index].spell.play_spell(speed)
func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	if movement_keys.has(piano_event.get_key()):
		handle_movement(piano_event)
	if easy_move_keys.has(piano_event.get_key()):
		handle_easy_movement(piano_event)
	
	if piano_event.get_key()==quick_menu_keys.front():
		handle_quick_menu(-1)
	if piano_event.get_key()==quick_menu_keys.back():
		handle_quick_menu(1)	
	if piano_event.get_key()=="E2":
		play_sound(1)
	if piano_event.get_key()=="D2":
		play_sound(2.5)		
	if !easy_move_keys.has(piano_event.get_key()) and !movement_keys.has(piano_event.get_key()) and !quick_menu_keys.has(piano_event.get_key()) and !piano_event.get_key()=="E2":	
		input_history.add(piano_event)
	piano_event.error_detected.connect(remove_event_from_history.bind(piano_event))
	piano_event.success_detected.connect(remove_event_from_history.bind(piano_event))
	_add_key_representation(piano_event)
	input_happened=true
	input_handled=false
	
	
func handle_input():
	traverse_sequences()
	#check_inputs()
	
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
		if movement_keys.has(a.get_key()):continue
		if a.related_sequences.is_empty():
			rem.append(a)
			
	for r:PianoEvent in rem: 
		r.error_detected.emit(EventStatus.new(EventStatus.StatusType.Unstarted,r,null))
	
	pass;	
	
var remove=[]



	
func traverse_sequences():
	var traversed_sequences=[]
	var keys=keyController.active_keys
	for sequence in sequences:
		if not is_instance_valid(sequence):
			continue
		if sequence.traverse(keys,beat.beat_no):
			traversed_sequences.append(sequence.spell.name)
		
	#if  window_open or allow_input_always:
	if true:
		for spell:Spell in equipped_spells:
			if traversed_sequences.has(spell.spell_name):
				l.d("continued")
				continue
			var maybe_seq=spell.check_start(keys,beat.beat_no)	
			if maybe_seq!=null:
				sequences.append(maybe_seq)
				maybe_seq.cancelled.connect(func():sequences.erase(maybe_seq))
				maybe_seq.remove.connect(func():sequences.erase(maybe_seq))
			
	var rem=[]
	for sequence in sequences:
		if not is_instance_valid(sequence):
			rem.append(sequence)
			continue
		if traversed_sequences.has(sequence.spell.spell_name):continue
		sequence.traverse(keys,beat.beat_no)
	for r in rem:
		sequences.erase(r)		
				
	pass # Replace with function body.
	
	
	
func timeout_sequences():
	var rem=[]
	for s in sequences:
		if not is_instance_valid(s):
			rem.append(s)
			continue
		if s.is_timeout(beat.beat_no):
			s.done=true
			remove.append(s)
			
	for r in rem:
		sequences.erase(r)
	for r in remove:
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
		handle_easy_movement(piano_event,true)
	#input_happened=true
	#input_handled=false
	pass # Replace with function body.


func _on_beat_beat() -> void:
	number_of_errors_unstarted-=1
	check_inputs()
	pass # Replace with function body.
