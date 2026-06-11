extends Node2D
class_name Explosion
static var instance=load('res://Scenes/explosion.tscn')
var damage
var hit_player=false
static func start(pos:Vector2,tree,dam,error_count,player=false):
	var i:Explosion=instance.instantiate()
	i.global_position=pos
	i.damage=(dam*error_count)
	i.scale*=(2-error_count)
	i.hit_player=player
	tree.get_root().add_child(i)
	
	pass

# Called when the node enters the scene tree for the first time.


@onready var area:Area2D=$Area2D
func _ready() -> void:
	print(area.collision_mask)
	if hit_player:
		area.set_collision_mask_value(20,true)
		print(area.collision_mask)
	await get_tree().physics_frame
	await get_tree().physics_frame
	explode()
	pass # Replace with function body.
func explode():
	for i in range(5):
		var pitch_scale=randf_range(0,0.2)
		var audio := AudioStreamPlayer.new()
		add_sibling(audio)
		audio.stream = preload("res://piano_keys/A440.wav")
		audio.pitch_scale = pitch_scale
		audio.volume_db=15
		audio.play()
		#audio.finished.connect(func():audio.queue_free())
		await get_tree().create_timer(8.0).timeout
		audio.queue_free()
	var enemies= area.get_overlapping_bodies()
	for e in enemies:
		if e.has_method("hit"):
			e.hit(damage,"Red")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
