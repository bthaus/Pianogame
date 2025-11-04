extends Node2D

var key_list=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	
	var rep=Label.new()
	var delay=0.0
	if not key_list.is_empty():
		var last=key_list.front()
		delay=piano_event.timestamp-last.timestamp
		
	rep.text=piano_event.get_key()+" delay: "+str(delay)+"ms"
	$spell.add_child(rep)
	key_list.push_front(piano_event)
	pass # Replace with function body.


func _on_key_controller_key_released(piano_event: PianoEvent) -> void:

	pass # Replace with function body.


func _on_button_pressed() -> void:
	var spell=Spell.new()
	
	pass # Replace with function body.
