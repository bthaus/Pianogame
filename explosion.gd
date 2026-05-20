extends Node2D
class_name Explosion
static var instance=load('res://Scenes/explosion.tscn')
var damage
static func start(pos:Vector2,tree,dam,error_count):
	var i:Explosion=instance.instantiate()
	i.global_position=pos
	i.damage=(dam*error_count)
	i.scale*=(2-error_count)
	
	tree.get_root().add_child(i)
	
	pass

# Called when the node enters the scene tree for the first time.


@onready var area=$Area2D
func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	explode()
	pass # Replace with function body.
func explode():
	var enemies= area.get_overlapping_bodies()
	for e:Enemy in enemies:
		e.hit(damage)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("entered")
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
