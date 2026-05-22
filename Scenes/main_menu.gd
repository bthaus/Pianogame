extends Node2D
@export var piano:Piano

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piano.keyController.key_pressed.connect(handle_input)
	pass # Replace with function body.
func handle_input(piano_event:PianoEvent):
	if piano_event.get_key()=="E4":
		start_game()
	if piano_event.get_key()=="B4":
		Piano.easy_move=!Piano.easy_move
		$CheckBox.visible=Piano.easy_move
	pass

func start_game():
	get_tree().change_scene_to_file("res://tests/worldtest.tscn")
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
