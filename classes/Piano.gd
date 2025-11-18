extends Node2D
class_name Piano

@onready var keyController:KeyController=$KeyController

@export var spells:Array[Spell]=[]
@onready var tree:Sequence_Tree=$SequenceTree
var frame_checked=false


func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	_add_key_representation(piano_event)
	call_deferred("check_spells")
	call_deferred("traverse_sequence_tree")
func traverse_sequence_tree():
	tree.traverse_tree(keyController.active_keys)
	pass	
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	frame_checked=false
	
func check_spells():
	if frame_checked:return
	frame_checked=true
	for spell in spells:
		var active=spell.check_activation(keyController.active_keys)	
		if active:print("Spell activated!")
func _add_key_representation(piano_event:PianoEvent):
	var label=Label.new()
	label.text=piano_event.get_key()
	label.name=piano_event.get_key()
	$PressedKeys.add_child(label)
	piano_event.representation=label


func _on_key_controller_before_key_released(piano_event: PianoEvent) -> void:
	piano_event.press_event.representation.queue_free()
	pass # Replace with function body.
