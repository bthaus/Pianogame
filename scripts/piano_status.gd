class_name EventStatus

enum StatusType{Unstarted, Cancelled, BadTiming, Success}
var type:StatusType

func _init(t:StatusType) -> void:
	self.type=t

func print_info():
	match type:
		StatusType.Unstarted: l.l("status type: Unstarted")
		StatusType.Cancelled: l.l("status type: Cancelled")
		StatusType.BadTiming: l.l("status type: BadTiming")
		StatusType.Success: l.l("status type: Success")
	
