extends Area2D
class_name EnemyScanner
@onready var tracker:Tracker=$'../Tracker'

var current_target:Enemy:
	set(value):
		current_target=value
		tracker.target=current_target
		
var overlapping_enemies:Array[Enemy]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		overlapping_enemies.append(body)
		current_target=overlapping_enemies.front()	
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Enemy:
		overlapping_enemies.erase(body)
		current_target=overlapping_enemies.front()	
	pass # Replace with function body.
