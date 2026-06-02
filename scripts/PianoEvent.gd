extends InputEventMIDI
class_name PianoEvent

var midi_event:InputEventMIDI
static var midi_notes = {
	21: "A0", 22: "A#0", 23: "B0",
	24: "C1", 25: "C#1", 26: "D1", 27: "D#1", 28: "E1", 29: "F1", 30: "F#1", 31: "G1", 32: "G#1",
	33: "A1", 34: "A#1", 35: "B1",
	36: "C2", 37: "C#2", 38: "D2", 39: "D#2", 40: "E2", 41: "F2", 42: "F#2", 43: "G2", 44: "G#2",
	45: "A2", 46: "A#2", 47: "B2",
	48: "C3", 49: "C#3", 50: "D3", 51: "D#3", 52: "E3", 53: "F3", 54: "F#3", 55: "G3", 56: "G#3",
	57: "A3", 58: "A#3", 59: "B3",
	60: "C4", 61: "C#4", 62: "D4", 63: "D#4", 64: "E4", 65: "F4", 66: "F#4", 67: "G4", 68: "G#4",
	69: "A4", 70: "A#4", 71: "B4",
	72: "C5", 73: "C#5", 74: "D5", 75: "D#5", 76: "E5", 77: "F5", 78: "F#5", 79: "G5", 80: "G#5",
	81: "A5", 82: "A#5", 83: "B5",
	84: "C6", 85: "C#6", 86: "D6", 87: "D#6", 88: "E6", 89: "F6", 90: "F#6", 91: "G6", 92: "G#6",
	93: "A6", 94: "A#6", 95: "B6",
	96: "C7", 97: "C#7", 98: "D7", 99: "D#7", 100: "E7", 101: "F7", 102: "F#7", 103: "G7", 104: "G#7",
	105: "A7", 106: "A#7", 107: "B7",
	108: "C8"
}
static var pitches = {
	"A0": 21, "A#0": 22, "B0": 23,
	"C1": 24, "C#1": 25, "D1": 26, "D#1": 27, "E1": 28, "F1": 29, "F#1": 30, "G1": 31, "G#1": 32,
	"A1": 33, "A#1": 34, "B1": 35,
	"C2": 36, "C#2": 37, "D2": 38, "D#2": 39, "E2": 40, "F2": 41, "F#2": 42, "G2": 43, "G#2": 44,
	"A2": 45, "A#2": 46, "B2": 47,
	"C3": 48, "C#3": 49, "D3": 50, "D#3": 51, "E3": 52, "F3": 53, "F#3": 54, "G3": 55, "G#3": 56,
	"A3": 57, "A#3": 58, "B3": 59,
	"C4": 60, "C#4": 61, "D4": 62, "D#4": 63, "E4": 64, "F4": 65, "F#4": 66, "G4": 67, "G#4": 68,
	"A4": 69, "A#4": 70, "B4": 71,
	"C5": 72, "C#5": 73, "D5": 74, "D#5": 75, "E5": 76, "F5": 77, "F#5": 78, "G5": 79, "G#5": 80,
	"A5": 81, "A#5": 82, "B5": 83,
	"C6": 84, "C#6": 85, "D6": 86, "D#6": 87, "E6": 88, "F6": 89, "F#6": 90, "G6": 91, "G#6": 92,
	"A6": 93, "A#6": 94, "B6": 95,
	"C7": 96, "C#7": 97, "D7": 98, "D#7": 99, "E7": 100, "F7": 101, "F#7": 102, "G7": 103, "G#7": 104,
	"A7": 105, "A#7": 106, "B7": 107,
	"C8": 108
};
var timestamp	
var representation
var press_event:PianoEvent
var related_sequences:Set=Set.new()
var checked_frames=0
var error_played=false
enum Progress{Active,Cancelled,Success}
var progress=Progress.Active

signal error_detected(status:EventStatus)
signal success_detected(status:EventStatus)


func _init(midi:InputEventMIDI) -> void:
	midi_event=midi
	timestamp=Time.get_ticks_msec()
	
func add_sequence(s:Sequence):
	related_sequences.add(s)
	s.finished.connect(remove_finished_sequence.bind(s))
	s.cancelled.connect(remove_cancelled_sequence.bind(s))
	
func remove_finished_sequence(s:Sequence):
	success_detected.emit(EventStatus.new(EventStatus.StatusType.Success,self,s))
	pass
func remove_cancelled_sequence(s:Sequence):
	
	related_sequences.rem(s)
	if related_sequences.is_empty():
		error_detected.emit(EventStatus.new(EventStatus.StatusType.Cancelled,self,s))	
		
	pass;		
func get_key()->String:
	return midi_notes[midi_event.pitch]	
func _print_midi_info():
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_NONE:return
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_ACTIVE_SENSING:return
	
	#if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_ON:
		#l.l(get_key()+" pressed!")
	#if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_OFF:
		#l.l(get_key()+" released!")

func handle_signal(pressed:Callable,released:Callable):
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_ON:
		pressed.call(self)
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_OFF:
		released.call(self)
	

func is_player_action()->bool:
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_ON: return true
	if midi_event.message==MIDIMessage.MIDI_MESSAGE_NOTE_OFF: return true
	
	return false
