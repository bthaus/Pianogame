extends Area2D
class_name Door
@export var player:PlayerCharacter
@export var unlock_spell:String
@export var next_position:Node2D

@export var locked=false
@export var state:DoorDirection
enum DoorDirection {ToWorld,ToSafeSpace,DeleteSpell}
static var return_position
static var return_scene
static var to_unlock
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.piano.keyController.key_pressed.connect(func(event:PianoEvent):
		if get_overlapping_bodies().is_empty():return
		if locked:return
		if event.get_key()!="E2":return
		
		if state==DoorDirection.DeleteSpell:
			delete_spell()	
			return
			
		if state==DoorDirection.ToSafeSpace:
			if next_position:
				return_position=next_position.global_position
			else:
				return_position=global_position
			if unlock_spell:	
				to_unlock=unlock_spell
			else:
				to_unlock=""
			get_tree().change_scene_to_file('res://world/Safe_space.tscn')
			return
		
		if state==DoorDirection.ToWorld:
			PlayerCharacter.spawnpoint=return_position
			get_tree().change_scene_to_file("res://scene/main/Level1.tscn")	
		
			
			
		)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
func delete_spell():
	get_parent().delete_spell()
	get_tree().change_scene_to_file("res://world/Safe_space.tscn")
	pass

func _on_body_entered(body: Node2D) -> void:
	if locked:return
	$Label.show()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	$Label.hide()
	pass # Replace with function body.
