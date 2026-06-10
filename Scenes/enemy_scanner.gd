extends Area2D
class_name EnemyScanner
@onready var tracker:Tracker=$'../Tracker'
@export var player:PlayerCharacter
signal target_changed(target)
var current_target:Enemy:
	set(value):
		current_target=value
		tracker.target=current_target
		if not is_instance_valid(current_target):
			target_changed.emit(null)
			return
		target_changed.emit(current_target)
		
var overlapping_enemies:Array[Enemy]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nearest=10000000000000
	var tempt=null
	for e:Enemy in overlapping_enemies:
		var distance=e.global_position-player.global_position
		if distance.x>0 and player.face_direction.x<0 or distance.x<0 and player.face_direction.x>0:
			#distance*2
			continue
		distance=distance.length_squared()
		player.face_direction
		if distance<nearest:
			nearest=distance
			tempt=e
	if tempt!=null and current_target!=tempt and is_instance_valid(tempt):		
		current_target=tempt
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		overlapping_enemies.append(body)
		body.died.connect(_on_body_exited.bind(body))
		current_target=overlapping_enemies.front()	
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Enemy:
		overlapping_enemies.erase(body)
		if overlapping_enemies.is_empty():current_target=null	
		else:current_target=overlapping_enemies.front()	
	pass # Replace with function body.
