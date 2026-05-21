class_name SequenceEdge
var max_int = 9223372036854775807
var keys = []
var to_node: SequenceNode
func _init(key_arr):
	keys = key_arr
	pass
func can_traverse(active_keys:Dictionary):
	var intersec=util.get_intersection(active_keys.keys(),keys)
	if intersec.size()!=keys.size():return false
	var off=0
	var smallest=max_int
	for key in intersec:
		if active_keys[key].timestamp<smallest:smallest=active_keys[key].timestamp
	for key in intersec:
		off+=active_keys[key].timestamp-smallest
	return off<60	
	
	
