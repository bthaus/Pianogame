extends Node2D

@export var player:PlayerCharacter
var average_accuracy:float=0.0
var sum:float=0.0:
	set(val):
		sum=val
		acc_counter+=1
		average_accuracy=sum/acc_counter
		$HUD/avgnum.text=str(snapped(average_accuracy,0.01))
		pass
var acc_counter:float=0.0		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(swap_spell_hint)
	call_deferred("connect_input")
	pass # Replace with function body.

func connect_input():
	player.piano.keyController.key_pressed.connect(func(event:PianoEvent):
		if event.get_key()=="C2":
			get_tree().change_scene_to_file('res://Scenes/stats.tscn')
			
		)
	for spell in player.piano.equipped_spells:
		print(spell.spell_name)	
		spell.triggered_node.connect(func(node:SequenceNode):
			sum+=abs(node.last_error_count)
			)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var graph
func _process(delta: float) -> void:
	
	var furthest:Sequence
	var remove=[]
	for a in player.piano.sequences:
		if not is_instance_valid(a):remove.append(a);continue
		furthest=a
	for r in remove:	
		player.piano.sequences.erase(r)	
	
	for sequence:Sequence in player.piano.sequences:
		if sequence.current_node.node_nr>furthest.current_node.node_nr:
			furthest=sequence
	if furthest==null:return	
	for c in $HUD/HBoxContainer.get_children():
		c.queue_free()	
	var cur=furthest.first_node
	if graph!=null:
		graph.queue_free()
	graph=$CanvasLayer/Graph2D.duplicate()
	$CanvasLayer.add_child(graph)
	graph.show()
	var item=graph.add_plot_item("")
	graph.y_max=0.3
	graph.y_min=-0.3
	var count=0
		
	while cur!=furthest.current_node:
		item.add_point(Vector2(count,cur.last_error_count))
		
		count+=1
		var label=Label.new()
		label.label_settings=$HUD/msg.label_settings.duplicate()
		label.text=str(snappedf(cur.last_error_count,0.01))+"/ "
		$HUD/HBoxContainer.add_child(label)		
		cur=cur.outgoing_edge.to_node
	graph.x_max=count
	var zero=graph.add_plot_item("")
	zero.add_point(Vector2(0,0))
	zero.add_point(Vector2(count,0))	
	pass

var counter=0
var active_visual
func swap_spell_hint():
	if active_visual!=null:active_visual.select(false)
	active_visual=player.piano.get_spell_visual(player.piano.equipped_spells.pick_random().spell_name)
	active_visual.select(true)
	player.store_data()
	pass
func _on_node_2d_message(string: Variant) -> void:
	counter+=1
	if counter>=1:
		counter=0
		swap_spell_hint()
	$HUD/msg.text=string
	pass # Replace with function body.
