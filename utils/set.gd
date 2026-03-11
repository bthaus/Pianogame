class_name Set

var content:Array=[]

func _init(arr=[]) -> void:
	content=arr

func add(a):
	if content.has(a):return
	content.append(a)
func rem(a):
	content.erase(a)
func add_set(b):
	for x in b.content:
		add(x)
func intersec(b:Set):
	return Set.new(util.get_intersection(content,b.content))

func get_diff(b:Set):
	return Set.new(util.get_difference(content,b.content))			

func is_partial(b:Set):
	return util.is_partial_sum(content,b.content)

func is_empty():
	return content.is_empty()
