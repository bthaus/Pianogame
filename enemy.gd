extends Character
class_name Enemy
var beat:Beat
var player:PlayerCharacter
var aggrod=false
func _ready() -> void:
	call_deferred("connect_beat")
	super()
var counter=0	
func connect_beat():
	beat=Beat.get_beat_instance()
	if beat==null:
		l.e("beat not passed")
	beat.bar.connect(move.bind(Vector2.ZERO))
	pass;
func move(direction,key="A1"):
	
	counter+=1
	if player==null:
		if counter%2==0:
			return super(Vector2i.RIGHT)
		else:
			return super(Vector2i.LEFT)	
			
	var dir=player.global_position-global_position
	if dir.length()>70:
		super(Vector2i(dir.normalized().x,0))
func play_anims(velocity):
	if velocity.x>0.1:
		$AnimatedSprite2D.play(&'walk')
	else:
		$AnimatedSprite2D.play(&'stand')	
	pass;

func shoot():
	var p=$Projectile.duplicate()
	add_sibling(p)
	p.global_position=global_position
	p.show()
	p.shoot((player.global_position-global_position).normalized())
	pass;
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter and not aggrod:
		player=body as PlayerCharacter
		beat.beat.connect(shoot)
		aggrod=true
	pass # Replace with function body.


func _on_projectile_body_entered(body: Node2D) -> void:
	
	pass # Replace with function body.
