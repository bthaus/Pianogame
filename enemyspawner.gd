extends Node2D

@export var player:PlayerCharacter

var types=[load('res://Scenes/ghost.tscn'),load('res://Scenes/Enemy.tscn')]
var enemies=[]
var number_of_enemies=2
@export var spawnpoints:Array[Node2D]=[]

func hit(damage):
	if not enemies.is_empty():return
	spawn_enemies()
	
	pass
func spawn_enemies():
	for i in range(number_of_enemies):
		get_tree().create_timer(i).timeout.connect(func():
			var enemy:Enemy=get_enemy()
			enemies.append(enemy)
			enemy.died.connect(func():enemies.erase(enemy))
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
