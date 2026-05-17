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
var notes:Array[Sprite2D]=[]
func set_up(node:SequenceNode,offset):
	var keys:Array=node.key_unit.key
	for k:String in keys:
		k=k.remove_chars("123456789UP")
		var sharp=k.contains("#")
		#$Line2D.visible=sharp
		k=k.replace("#","") 
		var off=offset_dic[k]*offset/2
		
		$Note/Line2D.visible= k.contains("C")
		var note:Sprite2D=$Note.duplicate()
		note.translate(Vector2(0,-off))
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
