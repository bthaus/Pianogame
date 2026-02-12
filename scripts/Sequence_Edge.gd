class_name SequenceEdge

var keys: Array[String] = []

func can_traverse(active_keys: Array[String]):
    return util.is_partial_sum(active_keys, keys)
