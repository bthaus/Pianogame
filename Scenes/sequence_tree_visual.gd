extends Node2D
class_name SequenceTreeVisual
@onready var line=%base_line
var tree:Sequence_Tree
const line_offset=30
@onready var indicator:Line2D=$indicator
var spell:Spell
func _process(delta: float) -> void:
	
	$ProgressBar.value=spell.get_number_of_correct_last_spells()
	$ProgressBar.max_value=spell.upgrade_values[spell.spell_name].front()
func _ready() -> void:
	
	pass
func set_up(spell:Spell):
	spell.cooldown_passed.connect(func():$notes.modulate=Color(1,1,1,1))
	spell.triggered.connect(func():$notes.modulate=Color(1,1,1,0.5))
	spell.spell_started.connect(start_move_indicator)
	spell.spell_failure_or_success.connect(stop_indicator)
	$Spellname.text=spell.spell_name
	self.tree=spell.tree
	var off=0
	for i in range(4):
		var li:Line2D=line.duplicate()
		off+=line_offset
		li.translate(Vector2(0,-off))
		add_child(li)
	off=line_offset
	for i in range(5):
		var li:Line2D=line.duplicate()
		off+=line_offset
		li.translate(Vector2(0,+off))
		add_child(li)	
	#for c in get_children():
		#c.queue_free()
	var current_node=tree.entry_edge.to_node
	var offset=Vector2.ZERO
	while true:
		var visual=	load('res://Scenes/sequence_node_visual.tscn').instantiate() as SequenceNodeVisual
		visual.set_up(current_node,line_offset)
		$notes.add_child(visual)
		#offset+=Vector2.RIGHT*50.0*current_node.beat
		visual.translate(Vector2.RIGHT*75.0*current_node.beat)
	
		if current_node.outgoing_edge!=null:
			current_node=current_node.outgoing_edge.to_node
		else:
			return	
	pass
func start_move_indicator():
	indicator.active=true
	pass;
func stop_indicator():
	indicator.active=false
	pass;	
