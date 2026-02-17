class_name SequenceEdge

var keys = []
var to_node: SequenceNode
func _init(key_arr):
	keys = key_arr
	pass
func can_traverse(active_keys: Array[String]):
	return util.is_partial_sum(active_keys, keys)
