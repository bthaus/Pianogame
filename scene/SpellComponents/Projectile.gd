extends Area2D
class_name Projectile

var direction:Vector2
var error_count
@export var color:String="White"
@export var speed:int=200
@export var damage=10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_body_entered)
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.
func hit(d,c):
	damage-=d
	if damage<=0:collide()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation=direction.angle()
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
	if body.has_method("hit"):
		body.hit(damage,color)	
		collide()
		return
	elif b.has_method("hit"):
		b.hit(damage,color)
		collide()
		return
	
	collide()	
	pass # Replace with function body.
