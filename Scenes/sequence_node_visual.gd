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
		
		
		var sharp=k.contains("#")
		#$Line2D.visible=sharp
		$Note/sharp.visible=sharp
		k=k.replace("#","") 	
		$Note/Line2D.visible= k=="C4"
		$Note/Line2D.visible= k=="C2" 
		if k=="C2" :
			var line=$Note/Line2D.duplicate()
			$Note.add_child(line)
			line.translate(Vector2.UP*offset)
		var octave=k[1]
		k=k.remove_chars("123456789UP")
		
		var off=offset_dic[k]*offset/2
		
		
		var note:Sprite2D=$Note.duplicate()
		note.translate(Vector2(0,-off))
		var oct=octave_offset[octave]
		note.translate(Vector2i(0,oct*7*offset/2))
		add_child(note)
		notes.append(note)
		note.show()
	print("connected "+util.strarr_to_string(keys))	
	node.hits_changed.connect(update_activity)
	pass;

func update_activity(node:SequenceNode):
	var val=node.hits
	for n in notes:
		if val>0:
			n.texture=active_text
		else:
			n.texture=inactive_text
			
	pass
