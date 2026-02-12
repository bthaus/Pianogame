extends Spell
class_name MelodySpell
var played_notes=[]
func check_activation(pressed_keys:Dictionary[String,PianoEvent])-> bool:
	
	var cumulative_note_error=0
	played_notes.append_array(pressed_keys.values())
	played_notes.sort_custom(sort_by_timestamp)
	var failure=played_notes.any(func(event:PianoEvent):
		return required_keys.all(func (note:Note):
			return event.get_key()!=note.key)
		)
		
	if failure:
		delete_attempt()
		return false
		
	var success = required_keys.all(func(note:Note):
		return played_notes.any(func(event:PianoEvent):
			return note.key==event.get_key()
			)
		)
	for i in range(played_notes.size()):
		if i==0:continue
		var actual_note_delay=played_notes[i].timestamp-played_notes[i-1].timestamp
		var actual_note_error=abs(actual_note_delay-required_keys[i].delay)	
		cumulative_note_error+=actual_note_error
		
	if cumulative_note_error>tolerance*1000: success=false			
	if success:
		delete_attempt()
		return true
	
	return false
		
	
	
	
	
func delete_attempt():
	played_notes.clear()
