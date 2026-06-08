extends Control
class_name Stats
var data
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.piano.keyController.key_pressed.connect(func(piano_event:PianoEvent):
		if piano_event.get_key()=="E2" and Main.shooter:
			get_tree().change_scene_to_file('res://tests/worldtest.tscn')
		if piano_event.get_key()=="E2" and !Main.shooter:
			get_tree().change_scene_to_file('res://tests/ungamed.tscn')	
		if piano_event.get_key()=="D2" :
			get_tree().change_scene_to_file('res://Scenes/main_menu.tscn')	
			
	)
	data=DataStorer.get_last_data()
	var average_accuracies={}
	if data["accuracy_histories"]==null:return
	var spell_names=data["accuracy_histories"].keys()
	var total_spells=0
	for key in spell_names:
		var value=0
		var sum=0
		for entry in data["accuracy_histories"][key]:
			value+=entry["val"]
			sum+=1	
		var spell_name=key
		total_spells+=sum
		if sum==0:average_accuracies[key]=0
		else:
			average_accuracies[key]=value/sum
	for spell in spell_names:
		var label=Button.new()
		label.text=spell+": "+str(average_accuracies[spell])	
		$player.unlock(spell,false)
		$Accuracies/container.add_child(label)
		
		
		label.pressed.connect(setup_graph.bind(spell))
	$total_errors.text+=str(data["total_missclicks"].size())
	$total_spells.text+=str(total_spells)
	if total_spells!=0 and data["total_missclicks"].size()!=0:
		$average_errors.text+=str(total_spells/data["total_missclicks"].size())
	$HUD.hide_player_stats()	
	for spell:Spell in $player.piano.equipped_spells:
		spell.triggered.connect(setup_graph.bind(spell.spell_name))
	$Camera2D.make_current()	
	pass # Replace with function body.

func setup_graph(spell_name):
	var index=0
	var graph=setup_graph_node($Graph2D)
	var item=graph.add_plot_item("timing error rates")
	graph.x_max=data["accuracy_histories"][spell_name].size()
	graph.y_max=5
	for entry in data["accuracy_histories"][spell_name]:
		item.add_point(Vector2(index,entry["val"]))
		index+=1
	
	
	var graph_errors=setup_graph_node($error_graph)
	var error_item=graph_errors.add_plot_item("errors with enemies")
	
	var max_enemies=0
	var average_dic={}
	for entry in data["accuracy_histories"][spell_name]:
		var ems:int=entry["enemies"]
		if ems>max_enemies:max_enemies=ems
		if not average_dic.has(ems):average_dic[ems]=[]
		average_dic[ems].append(entry["val"])
	var arr=[]
	for i in range(max_enemies):
		if not average_dic.has(i):continue
		if average_dic[i].size()	==0: continue
		var count=average_dic[i].size()	
		var sum=0
		for entry in average_dic[i]:
			sum+=entry
		if count!=0 and sum!=0:	
			error_item.add_point(Vector2(i,sum/count))
	graph_errors.x_max=max_enemies
	graph_errors.y_max=5	
	
	
	var hp=setup_graph_node($hp_graph)
	var hp_item=hp.add_plot_item("errors with hp")
	
	var max_hp=0
	average_dic={}
	var hp_array=[]
	for entry in data["accuracy_histories"][spell_name]:
		var ems:int=entry["hp"]
		if ems>max_hp:max_hp=ems
		if not average_dic.has(ems):average_dic[ems]=[]
		average_dic[ems].append(entry["val"])
		if not hp_array.has(ems):hp_array.append(ems)
		
		
	arr=[]
	hp_array.sort()
	#todo: fix the calculation at average dic, 
	for k in hp_array:
		if not average_dic.has(k):continue
		if average_dic[k].size()	==0: continue
		var count=average_dic[k].size()	
		var sum=0
		for entry in average_dic[k]:
	
			sum+=entry
		if count!=0 and sum!=0:	
			hp_item.add_point(Vector2(k,sum/count))
	hp.x_max=max_hp
	hp.y_max=5	
	var imp=setup_graph_node($improvement_graph)
	var impi=imp.add_plot_item("improvement")
	imp.x_max=data["accuracy_histories"][spell_name].size()
	var data_arr=[]
	for a in data["accuracy_histories"][spell_name]:
		data_arr.append(a["val"])
	var points=get_regression_line_points(data_arr)
	impi.add_point(Vector2(0,points["start_y"]))
	impi.add_point(Vector2(imp.x_max,points["end_y"]))
	imp.y_max=max(points["start_y"],points["end_y"])
	imp.y_min=min(points["start_y"],points["end_y"])
	#
	#index=0
	##(Yi+1-Yi-1)/(Xi+1-Xi-1)
	#var smoothess=data["accuracy_histories"][spell_name].size()/5
	#var smooth=smooth_points(data["accuracy_histories"][spell_name],smoothess)
	#var max=0
	#var min=0
	#var derivatives=[]
	#for i in range(smooth.size()):
		## Randpunkte überspringen
		#if i == 0 or i == smooth.size() - 1:
			#continue
		#
		#var prev = smooth[i - 1]
		#var next = smooth[i + 1]
#
		##var dx = i+1 - i-1
##
		### Safety gegen Division durch 0
		##if dx == 0:
			##continue
#
		#var dy = next - prev
#
		#var result = dy / (-2)
		#if result>max:max=result
		#if result<min:min=result
		#derivatives.append(result)
		#impi.add_point(Vector2(i,result))
		##derivatives.append(Vector2(smooth[i].x, result))
	#imp.y_max=max
	#imp.y_min=min
	#var zero=imp.add_plot_item("")
	#zero.add_point(Vector2(0,0))
	#zero.add_point(Vector2(smooth.size(),0))
	pass
func smooth_points(points: Array, window_size := 2) -> Array:
	var result = []

	if points.is_empty():
		return result

	for i in range(points.size()):
		var sum := 0.0
		var count := 0

		for offset in range(-window_size, window_size + 1):
			var index := i + offset

			# Access safety
			if index < 0:
				continue

			if index >= points.size():
				continue

			sum += points[index]["val"]
			count += 1

		# Extra safety gegen Division durch 0
		if count == 0:
			result.append(points[i]["val"])
			continue

		var avg := sum / count

		result.append(avg)

	return result
func setup_graph_node(node:Control):
	
	var graph=Graph2D.new()
	graph.custom_minimum_size=Vector2(350,350)
	for child in node.get_children():
		child.queue_free()
	node.add_child(graph)
	return graph
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$player.global_position=Vector2.ZERO
	pass
	
func get_regression_line(data: Array) -> Dictionary:
	var n := data.size()

	if n < 2:
		return {
			"slope": 0.0,
			"intercept": data[0] if n == 1 else 0.0
		}

	var sum_x := 0.0
	var sum_y := 0.0
	var sum_xy := 0.0
	var sum_x2 := 0.0

	for i in range(n):
		var x := float(i)
		var y := float(data[i])

		sum_x += x
		sum_y += y
		sum_xy += x * y
		sum_x2 += x * x

	var denominator := (n * sum_x2) - (sum_x * sum_x)

	if denominator == 0.0:
		return {
			"slope": 0.0,
			"intercept": 0.0
		}

	var slope := ((n * sum_xy) - (sum_x * sum_y)) / denominator
	var intercept := (sum_y - slope * sum_x) / n

	return {
		"slope": slope,
		"intercept": intercept
	}	


func get_regression_line_points(data: Array) -> Dictionary:
	var line := get_regression_line(data)

	var slope = -line.slope
	var intercept = line.intercept

	var start_x := 0.0
	var end_x := float(data.size())

	var start_y = slope * start_x + intercept
	var end_y = slope * end_x + intercept

	return {
		"start_y": start_y,
		"end_y": end_y
	}	
