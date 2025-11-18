extends Resource
class_name Spell

@export var required_keys:Array[Note]=[]


@export var tolerance=0.2
@export var spell_name=""

func check_activation(pressed_keys:Dictionary[String,PianoEvent])-> bool:
	
	var active=true
	var delay=0
	
	var failure=required_keys.any(func(note:Note):
		return !pressed_keys.has(note.key)
		)
	if failure:return false
	active = required_keys.all(func(note:Note):
		return pressed_keys.values().any(func(event:PianoEvent):
			return note.key==event.get_key()
			)
		)	
		
	#if pressed_keys.size()>required_keys.size(): return false	
	var events=pressed_keys.values()
	events.sort_custom(sort_by_timestamp)
	for i in range(events.size()):
		if i==0:continue
		delay+=events[i].timestamp-events[i-1].timestamp	

	if delay>tolerance*1000: active=false		
	return active

func sort_by_timestamp(a:PianoEvent,b:PianoEvent):
	if a.timestamp < b.timestamp:
		return true
	return false
