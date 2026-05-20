extends CharacterBody2D
class_name Character

var movement_speed=300
@export var jumping_curve:Curve

@export var jumping_speed=300
@onready var map:TileMapLayer=$'../TileMapLayer'
@onready var projectile_pos:Node2D=$projectileposition
@onready var shield_pos:Node2D=$shield_pos
var jumping=false
var face_direction=Vector2.RIGHT:
	set(val):
		face_direction=val
		$AnimatedSprite2D.flip_h=face_direction==Vector2.LEFT
var map_position	
var target_position
signal hp_changed()
var max_hp=0
signal died
var frozen=false
@export var hp=100:
	set(value):
		hp=value
		l.d("hp:" +str(hp))
		hp_changed.emit()
func _process(delta: float) -> void:
	pass
func _ready() -> void:
	call_deferred("get_map")
	max_hp=hp
	hp=hp
func get_map():
	map=Map.get_map()
	map_position=map.local_to_map(global_position)
	target_position=map_position as Vector2
	pass	
func jump():
	if jumping:return
	if is_on_floor():
		velocity.y=-jumping_speed
	jumping=true
func move(direction,key="A1"):
	face_direction=direction
	if frozen:return
	is_on_wall()
	if direction.x>0 and $front.has_overlapping_bodies():target_position=map_position;return
	if direction.x<0 and $back.has_overlapping_bodies():target_position=map_position;return
	target_position+=direction
	pass;

var last_pos=Vector2.ZERO	
func _physics_process(delta: float) -> void:
	if target_position==null:return
	map_position=map.local_to_map(global_position)as Vector2
	if hp<=0:
		return
	velocity.y += 800 * delta
	#if map_position!=target_position:
	determine_x_velocity(delta)
	velocity.x = clamp(velocity.x, -movement_speed, movement_speed)
	var test=velocity
	play_anims(velocity)
	var x=global_position.x		
	move_and_slide()	
	var x2=global_position.x
	#if x==x2:
		#target_position.x=map_position.x
	pass
func reset_positions():
	map_position=map.local_to_map(global_position)as Vector2
	target_position=map_position
	pass;	
func determine_x_velocity(delta):
	var target_x = (map.map_to_local(target_position) ).x
	velocity.x = (target_x - global_position.x) * 10.0
	pass	
func play_anims(velocity):
	if jumping:
		$AnimatedSprite2D.play(&'jump')
	elif abs(velocity.x)>1:
		$AnimatedSprite2D.play(&'walk')
	else:
		$AnimatedSprite2D.play(&"stand")
	pass		

var shields=[]
func hit(damage):
	if not shields.is_empty():
		for shield in shields:
			if damage <= 0:
				break

			# absorb as much damage as possible
			var absorbed = min(shield.hp, damage)

			shield.hp -= absorbed
			damage -= absorbed
	hp-=damage
	$AnimatedSprite2D.play(&'hurt')
	if hp<0:
		die()
	pass
func die():
	collision_layer=0
	died.emit()
	var tween=create_tween()
	tween.tween_property($AnimatedSprite2D,"position",Vector2(0,50),2)
	#create_tween().tween_property(self,"rotation",deg_to_rad(-90),1)
	tween.tween_callback(queue_free)
	pass
func _on_ground_box_body_entered(body: Node2D) -> void:
	jumping=false
	pass # Replace with function body.
