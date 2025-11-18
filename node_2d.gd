extends Node2D
class_name KeyController
signal key_pressed(piano_event:PianoEvent)
signal key_released(piano_event:PianoEvent)
@export var debug_active=true
var active_keys:Dictionary[String,PianoEvent]={}
signal before_key_released(piano_event:PianoEvent)

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
func _process(delta: float) -> void:
	
			
	if debug_active:
		check_keyboard()
func _input(input_event):
	
	if input_event is InputEventMIDI:
		input_event=PianoEvent.new(input_event)
		input_event.handle_signal(_on_key_pressed,_on_key_released)
	

func check_keyboard():
	
	if Input.is_action_just_pressed(&'C'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=60
		fake_event.message=MIDI_MESSAGE_NOTE_ON
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)		

	if Input.is_action_just_pressed(&"D"):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=64
		fake_event.message=MIDI_MESSAGE_NOTE_ON
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	if Input.is_action_just_pressed(&'E'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=67	
		fake_event.message=MIDI_MESSAGE_NOTE_ON	
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	if Input.is_action_just_pressed(&'F'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=69
		fake_event.message=MIDI_MESSAGE_NOTE_ON
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	
	if Input.is_action_just_released(&'C'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=60
		fake_event.message=MIDI_MESSAGE_NOTE_OFF
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	if Input.is_action_just_released(&"D"):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=64
		fake_event.message=MIDI_MESSAGE_NOTE_OFF
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	if Input.is_action_just_released(&'E'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=67
		fake_event.message=MIDI_MESSAGE_NOTE_OFF	
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	
	if Input.is_action_just_released(&'F'):
		var fake_event=InputEventMIDI.new()
		fake_event.pitch=69
		fake_event.message=MIDI_MESSAGE_NOTE_OFF	
		var fake_piano_event=PianoEvent.new(fake_event)
		fake_piano_event.handle_signal(_on_key_pressed,_on_key_released)	


func _on_key_pressed(piano_event: PianoEvent) -> void:
	if active_keys.has(piano_event.get_key()):
		print("stray press event caught")
		return	
	active_keys[piano_event.get_key()]=piano_event
	key_pressed.emit(piano_event)
	pass # Replace with function body.


func _on_key_released(piano_event: PianoEvent) -> void:
	if not active_keys.has(piano_event.get_key()):
		print("stray release event caught")
		return
	piano_event.press_event=active_keys[piano_event.get_key()]	
	before_key_released.emit(piano_event)	
	active_keys.erase(piano_event.get_key())
	key_released.emit(piano_event)
	pass # Replace with function body.
