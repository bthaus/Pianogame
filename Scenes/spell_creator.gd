extends Node2D

var key_list = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_key_controller_key_pressed(piano_event: PianoEvent) -> void:
	var rep = Label.new()
	var delay = 0.0
	if not key_list.is_empty():
		var last = key_list.front()
		delay = piano_event.timestamp - last._timestamp
		
	rep.text = piano_event.get_key() + " delay: " + str(delay) + "ms"
	$spell.add_child(rep)
	var note = Note.new(piano_event.get_key(), delay)
	key_list.push_front(note)
	pass # Replace with function body.


func _on_key_controller_key_released(piano_event: PianoEvent) -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	var spell: Spell
	if $simul.button_pressed:
		spell = Spell.new()
	if $melody.button_pressed:
		spell = MelodySpell.new()
		
	spell.spell_name = $Name.text
	for key: Note in key_list:
		spell.required_keys.push_front(key)
	ResourceSaver.save(spell, "res://Ressources/Spells/" + $Name.text + ".tres")
	pass # Replace with function body.


func _on_reset_pressed() -> void:
	key_list.clear()
	for child in $spell.get_children():
		if child == $spell/Spells: continue
		child.queue_free()
	pass # Replace with function body.
