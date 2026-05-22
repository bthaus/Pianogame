
extends Node2D
class_name KeyController
signal key_pressed(piano_event: PianoEvent)
signal key_released(piano_event: PianoEvent)
@export var debug_active = true
var active_keys: Dictionary[String, PianoEvent] = {}
signal before_key_released(piano_event: PianoEvent)
static var midi_open=false
func _ready():
	if midi_open:return
	midi_open=true
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
func _input(input_event):
	if input_event is InputEventMIDI:
		input_event = PianoEvent.new(input_event)
		input_event.handle_signal(_on_key_pressed, _on_key_released)
	

func _on_key_pressed(piano_event: PianoEvent) -> void:
	if active_keys.has(piano_event.get_key()):
		print("stray press event caught")
		return
	active_keys[piano_event.get_key()] = piano_event
	l.d(piano_event.get_key())
	key_pressed.emit(piano_event)
	pass # Replace with function body.


func _on_key_released(piano_event: PianoEvent) -> void:
	if not active_keys.has(piano_event.get_key()):
		print("stray release event caught")
		return
	piano_event.press_event = active_keys[piano_event.get_key()]
	before_key_released.emit(piano_event)
	active_keys.erase(piano_event.get_key())
	#return
	active_keys[piano_event.get_key()+"UP"]=piano_event
	key_released.emit(piano_event)
	pass # Replace with function body.
