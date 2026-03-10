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

##returns all elements of a that are not in b
static func get_difference(a:Array,b:Array)->Array:
	var temp=[]
	for x in a:
		if not b.has(x):
			temp.push_back(x)
	return temp		

static func strarr_to_string(arr):
	var str=""
	for a in arr:
		str+=a
	return str

static func seconds_from_beats_and_bpm(beats,bpm):
	return beats*60/bpm
