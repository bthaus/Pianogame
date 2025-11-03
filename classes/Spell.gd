extends Resource
class_name Spell

@export var required_keys:Dictionary[String,int]={}
@export var simultaneos=true
@export var tolerance=0.2

func check_activation(pressed_keys:Dictionary[String,PianoEvent])-> bool:
	if pressed_keys.size()>required_keys.size(): return false	
	var active=true
	var delay=0
	var events=[]
	for key in required_keys:
		if not pressed_keys.has(key):
			active=false
			break
		events.push_back(pressed_keys[key])
	
	events.sort_custom(sort_by_timestamp)
	for i in range(events.size()):
		if i==0:continue
		
		delay+=events[i].timestamp-events[i-1].timestamp	
	print(delay)	
	if delay>tolerance*1000: active=false		
	return active
	
func sort_by_timestamp(a:PianoEvent,b:PianoEvent):
	if a.timestamp < b.timestamp:
		return true
	return false
