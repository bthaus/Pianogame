extends World
class_name SafeSpace
var counter=0
@export var door:Door
@export var spell_creator:SpellCreator
@export var standing_position:Area2D
@export var spell_creator_nodes:Node

var custom_spell_mode=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Door.to_unlock!=null:
		if player.learned_spells.has(Door.to_unlock):return
		if Door.to_unlock=="Custom":
			prepare_custom_spell()
			return
		if Door.to_unlock=="":
			return	
		spell_creator_nodes.queue_free()	
		$Label.show()
		door.locked=true
		var unlockable:Unlockable=load("res://Scenes/unlockable.tscn").instantiate()
		unlockable.spell_name=Door.to_unlock
		$Unlockspot.add_child(unlockable)
		unlockable.picked_up.connect(func():
			$Label.show()
			var spell=player.piano.get_spell_instance(Door.to_unlock)	
			spell.triggered.connect(increase_counter)	
			)
		
		
	pass # Replace with function body.
var color	
func prepare_custom_spell():
	color=Enemy.colors.pick_random()
	$spell_creator_podium.color=Enemy.color_dic[color]
	spell_creator_nodes.show()
	custom_spell_mode=true
	pass	
func increase_counter():
	counter+=1
	$Label.text="Cast your new spell "+str(3-counter)+" times to unlock the door."
	if counter==3:
		door.locked=false
		
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not custom_spell_mode:return
	
	pass

var vol
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not custom_spell_mode:return
	spell_creator.keys.clear()
	$spell_creator_podium/Label.show()
	vol=player.piano.find_child("error").volume_db
	player.piano.find_child("error").volume_db=-80
	pass # Replace with function body.

func delete_spell():
	#player.piano.remove_spell(spell_name)
	player.learned_spells.erase(spell_name)
	DataStorer.delete_spell(spell_name)
	SpellFactory.spells.erase(spell_name)
	pass
var spell_name	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if not custom_spell_mode:return
	player.piano.find_child("error").volume_db=vol
	$spell_creator_podium/Label.hide()
	var spell:Spell=spell_creator.get_spell(color)
	if spell==null:return
	player.piano.add_spell(spell)
	spell_name=spell.spell_name
	player.learned_spells.append(spell.spell_name)
	var dictionary={"Color"=color,
		"Data"=spell.full_input,
		"Name"=spell.spell_name}
	DataStorer.store_custom_spell(dictionary)
	spell_creator_nodes.queue_free()
	var door:Door=$exit.duplicate()
	door.unlock_spell="Custom"
	door.state=Door.DoorDirection.DeleteSpell
	door.global_position=Vector2.ZERO
	add_child(door)
	pass # Replace with function body.
