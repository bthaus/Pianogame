extends Node2D
class_name SequenceNodeVisual
var active_text=load('res://Assets/UI/note_active.png')
var inactive_text=load('res://Assets/UI/note.png')

var offset_dic={
	"C"=0,
	"D"=1,
	"E"=2,
	"F"=3,
	"G"=4,
	"A"=5,
	"B"=6
}
var octave_offset={
	"2"=2,
	"3"=1,
	"4"=0,
	"5"=-1,
	"6"=-2
}

var notes:Array[Sprite2D]=[]
func set_up(node:SequenceNode,offset):
	var keys:Array=node.key_unit.key
	for k:String in keys:
		
		var full_note=k
		var sharp=k.contains("#")
		#$Line2D.visible=sharp
		$Note/sharp.visible=sharp
		k=k.replace("#","") 	
		$Note/Line2D.visible= k.contains("C4") or k.contains("C2") 
		$Note/Line2D2.visible= k.contains("C2") 
		var octave=k[1]
		
		k=k.remove_chars("123456789UP")
		
		var off=offset_dic[k]*offset/2
		
		
		
		var note:Sprite2D=$Note.duplicate()
		note.translate(Vector2(0,-off))
		var oct=octave_offset[octave]
		note.translate(Vector2(0,oct*7*offset/2))
		add_child(note)
		notes.append(note)
		note.show()
		var piano=Piano.get_piano()
		piano.keyController.key_pressed.connect(func(event:PianoEvent):
			if event.get_key()==full_note:note.texture=active_text)
		piano.keyController.key_released.connect(func(event:PianoEvent):
			if event.get_key()==full_note:note.texture=inactive_text)
		
	
	node.hits_changed.connect(update_activity)
	pass;
func highlight():
	for n in notes:
		n.texture=active_text
	pass
func unhighlight():
	for n in notes:
		n.texture=inactive_text
	pass	
func update_activity(node:SequenceNode):
	var val=node.hits
	for n in notes:
		if val>0:
			n.texture=active_text
		else:
			n.texture=inactive_text
			
	pass
