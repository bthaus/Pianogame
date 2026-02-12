class_name util


##checks if all elements of b are within a. if an element in b exists which does not exist in a return false
static func is_partial_sum(a: Array, b: Array) -> bool:
    for x in b:
        if not a.has(x):
            return false
    return true

##return all elements that are in both arrays
static func get_intersection(a: Array, b: Array) -> Array:
    var intersection = []
    for x in b:
        if a.has(x):
            intersection.push_back(x)
    return intersection
