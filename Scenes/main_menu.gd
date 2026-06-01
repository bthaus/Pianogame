extends Node2D
class_name Main
@export var piano:Piano
static var shooter=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piano.keyController.key_pressed.connect(handle_input)
	pass # Replace with function body.
func handle_input(piano_event:PianoEvent):
	if piano_event.get_key()=="E4":
		start_shooter()
	if piano_event.get_key()=="G4":
		start_base_defense()	
	if piano_event.get_key()=="B4":
		get_tree().change_scene_to_file('res://Scenes/stats.tscn')
	pass
func start_base_defense():
	get_tree().change_scene_to_file('res://Scenes/base_defense.tscn')
	pass
func start_shooter():
	shooter=true
	get_tree().change_scene_to_file("res://tests/worldtest.tscn")
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
