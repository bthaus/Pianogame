extends Node2D
class_name SequenceTreeVisual
@onready var line=%base_line
var tree:Sequence_Tree
const line_offset=30
@onready var indicator:Line2D=$indicator
var spell:Spell
@export var selector:Sprite2D
func _process(delta: float) -> void:
	if spell.get_number_of_correct_last_spells()==null:return
	$ProgressBar.value=spell.get_number_of_correct_last_spells()
	$ProgressBar.max_value=spell.upgrade_values[spell.spell_name].front()
func _ready() -> void:
	$Spellname.label_settings=$Spellname.label_settings.duplicate()
	
	pass
func highlight():
	$Spellname.label_settings.font_color=Color(0.0, 0.747, 0.638, 1.0)

	pass
func select(on):
	selector.visible=on
	pass	
func unhighlight():
	$Spellname.label_settings.font_color=Color(0.0, 0.0, 0.0, 1.0)

	pass	
static var visual_dic={}
func charges_changed(value):
	for i in range(value):
		$charges.get_child(i).get_child(0).show()
	for i in range(value,$charges.get_child_count()):
		$charges.get_child(i).get_child(0).hide()	
	
	pass		
func set_up(spell:Spell):
	spell.cooldown_passed.connect(func():$notes.modulate=Color(1,1,1,1))
	spell.triggered.connect(func():
		if spell.cooldown_in_beats>=1:
			$notes.modulate=Color(1,1,1,0.5))
	spell.spell_started.connect(start_move_indicator)
	spell.spell_failure_or_success.connect(stop_indicator)
	spell.charges_changed.connect(charges_changed)
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
		visual_dic[current_node.key_unit]=visual
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
