class_name EventStatus

enum StatusType{Unstarted, Cancelled, BadTiming, Success}
var type:StatusType
var event:PianoEvent
##either last active sequence or played sequence
var related_sequence:Sequence

func _init(t:StatusType,e:PianoEvent,s:Sequence) -> void:
	self.type=t
	related_sequence=s
	event=e


func print_info():
	match type:
		StatusType.Unstarted: l.l("status type: Unstarted")
		StatusType.Cancelled: l.l("status type: Cancelled")
		StatusType.BadTiming: l.l("status type: BadTiming")
		StatusType.Success: l.l("status type: Success")
	if type!=StatusType.Unstarted:	
		l.l("for spell: "+related_sequence.spell.name)
