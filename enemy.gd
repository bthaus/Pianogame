extends Character
class_name Enemy
var beat:Beat
var player:PlayerCharacter
var aggrod=false
@onready var center:Node2D=$center
var colors=["Red","Blue","Green","White","Yellow"]
static var unlocked_colors=["White"]
var color_dic={
	"Red"=Color(1.0, 0.0, 0.0, 1.0),
	"Blue"=Color(0.0, 0.0, 1.0, 1.0),
	"Green"=Color(0.0, 1.0, 0.0, 1.0),
	"White"=Color(1.0, 1.0, 1.0, 1.0),
	"Yellow"=Color(1.0, 1.0, 0.0, 1.0)
}
var color
static var num_alive=0:
	set(val):
		num_alive=clamp(val,0,10000)
		pass
func set_color():
	color="Yellow"
	pass		
func _ready() -> void:
	set_color()
	$AnimatedSprite2D.modulate=color_dic[color]
	call_deferred("connect_beat")
	num_alive+=1
	super()
var counter=0	
func connect_beat():
	beat=Beat.get_beat_instance()
	if beat==null:
		l.e("beat not passed")
	beat.bar.connect(move.bind(Vector2.ZERO))
	beat.beat.connect(squish)
	pass;
func squish():
	var tw=create_tween()
	tw.tween_property(self,^"scale",Vector2(1,0.5),60/beat.bpm/2)
	tw.tween_property(self,^"scale",Vector2(1,1),60/beat.bpm/2)
	pass	
func move(direction,key="A1"):
	
	counter+=1
	if player==null:
		if counter%2==0:
			return super(Vector2.RIGHT)
		else:
			return super(Vector2.LEFT)	
			
	var dir=player.global_position-global_position
	if max_proximity_to_player()<abs(dir.length()):
		super(Vector2(dir.normalized().x,0))
func play_anims(velocity):
	if velocity.x>0.1:
		$AnimatedSprite2D.play(&'walk')
	else:
		$AnimatedSprite2D.play(&'stand')	
	pass;
func max_proximity_to_player():
	return 70
func hit(damage,c):
	if not is_instance_valid(player):return
	if c==color:
		damage*=2
	else:
		damage/=2	
	if player.movement_locked:damage=damage*2
	super(damage,c)	
func shoot():
	
	if frozen:return
	if hp<=0:
		die()
		return
	var distance=(player.global_position-global_position).length()
	if distance>100:return	
	var p=$Projectile.duplicate()
	add_sibling(p)
	p.global_position=global_position
	p.show()
	p.shoot((player.global_position-global_position).normalized())
	pass;
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter and not aggrod:
		player=body as PlayerCharacter
		connect_action()
		aggrod=true
	pass # Replace with function body.
func connect_action():
	beat.beat.connect(shoot)
	pass
func die():
	num_alive-=1
	super()
	pass
func _on_projectile_body_entered(body: Node2D) -> void:
	
	pass # Replace with function body.
