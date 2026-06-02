extends World
class_name SafeSpace
var counter=0
@export var door:Door
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Door.to_unlock!=null:
		if player.learned_spells.has(Door.to_unlock):return
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
func increase_counter():
	counter+=1
	$Label.text="Cast your new spell "+str(3-counter)+" times to unlock the door."
	if counter==3:
		door.locked=false
		
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
