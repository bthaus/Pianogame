extends Area2D
class_name Projectile

var direction:Vector2
@export var speed:int=200
var damage=10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_body_entered)
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(direction*speed*delta)
	pass

func collide():
	queue_free()
	pass;
func shoot(dir):
	monitorable=true
	monitoring=true
	direction=dir
	pass;
func _on_body_entered(body: Node2D) -> void:
	var b=body.get_parent()
	if b.has_method("hit"):
		b.hit(damage)
	if body.has_method("hit"):
		body.hit(damage)	
	collide()	
	pass # Replace with function body.
