extends Node2D

@export var player:PlayerCharacter

@export var types:Array[PackedScene]=[]
var enemies=[]
@export var number_of_enemies=[2,4]:
	set(value):
		number_of_enemies=value
		
@export var spawnpoints:Array[Node2D]=[]
@export var reward_spell:String
func handle_enemies_defeated():
	if number_of_enemies.is_empty():
		give_reward()
	pass

func give_reward():
	var reward=load('res://Scenes/unlockable.tscn').instantiate()
	reward.spell_name=reward_spell
	add_sibling(reward)
	reward.global_position=global_position
	queue_free()
	pass

func hit(damage):
	if not enemies.is_empty():return
	spawn_enemies()
	
	pass
func spawn_enemies():
	for i in range(number_of_enemies.pop_front()):
		get_tree().create_timer(i).timeout.connect(func():
			var enemy:Enemy=get_enemy()
			enemies.append(enemy)
			enemy.died.connect(func():
				enemies.erase(enemy)
				if enemies.is_empty():
					handle_enemies_defeated()
				)
			spawnpoints.pick_random().add_child(enemy)
			)
	
		
	pass;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_enemy():
	return types.pick_random().instantiate()
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
