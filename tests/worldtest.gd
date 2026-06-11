extends Node2D
class_name World
@export var day=false
@export var player:PlayerCharacter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_wall():
	$wall.queue_free()
	


func _on_day_setter_body_entered(body: Node2D) -> void:
	day=true
	$CanvasModulate.hide()
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	$boss_camera.make_current()
	Beat.beat_instance.start_boss_music()
	pass # Replace with function body.
