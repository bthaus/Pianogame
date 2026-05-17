extends Node2D
class_name SequenceTreeVisual
@onready var line=%base_line
var tree:Sequence_Tree
const line_offset=30
func set_up(tree:Sequence_Tree):
	var off=0
	for i in range(4):
		var li:Line2D=line.duplicate()
		off+=line_offset
		li.translate(Vector2(0,-off))
		add_child(li)
		
	#for c in get_children():
		#c.queue_free()
	var current_node=tree.entry_edge.to_node
	var offset=Vector2.ZERO
	while true:
		var visual=	load('res://Scenes/sequence_node_visual.tscn').instantiate() as SequenceNodeVisual
		visual.set_up(current_node,line_offset)
		add_child(visual)
		offset+=Vector2.RIGHT*50.0*current_node.beat
		visual.translate(offset)
	
		if current_node.outgoing_edge!=null:
			current_node=current_node.outgoing_edge.to_node
		else:
			return	
	pass
