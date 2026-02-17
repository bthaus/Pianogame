extends Node2D
class_name SequenceNodeVisual
var active_text=load('res://Assets/node_blue.png')
var inactive_text=load('res://Assets/node_white.png')
func set_up(node:SequenceNode):
	$Note/Label.text=util.strarr_to_string(node.incoming_edge.keys) 
	node.hits_changed.connect(update_activity)
	pass;

func update_activity(val:int):
	$Note/hitno.text=str(val)
	if val>0:
		$Note.texture=active_text
	else:
		$Note.texture=inactive_text
		
	pass
