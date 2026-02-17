extends Node2D
class_name SequenceTreeVisual

var tree:Sequence_Tree

func set_up(tree:Sequence_Tree):
	for c in get_children():
		c.queue_free()
	var current_node=tree.entry_edge.to_node
	var offset=Vector2.ZERO
	while true:
		var visual=	load('res://Scenes/sequence_node_visual.tscn').instantiate() as SequenceNodeVisual
		visual.set_up(current_node)
		add_child(visual)
		visual.translate(offset)
		offset+=Vector2.DOWN*100
		if current_node.outgoing_edge!=null:
			current_node=current_node.outgoing_edge.to_node
		else:
			return	
	pass
