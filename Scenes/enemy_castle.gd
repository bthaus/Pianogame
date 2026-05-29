extends Sprite2D

@export var enemies:Array[PackedScene]=[]
@export var player:PlayerCharacter
var hp=100
var max_hp=100
static var hp_arr=[100,150,200,250,300]
static var timer_arr=[4,3,2.5,2,1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_hp=hp_arr.front()
	hp=max_hp
	
	var beat=Beat.get_beat_instance()
	beat.beat.connect(do_action)
	pass # Replace with function body.
var accum=0
func do_action():
	accum+=1
	if accum>=timer_arr.front():
		spawn_enemy()
		accum=0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t=1
	var color=remap(hp,0,max_hp,0,t)
	$ProgressBar.self_modulate=Color(t-color,color,0,t)
	$ProgressBar.max_value=max_hp
	$ProgressBar.value=hp
	pass
func hit(damage):
	hp-=damage
	if hp<=0:
		hp_arr.pop_front()
		timer_arr.pop_front()
		player.die()
	pass

func spawn_enemy() -> void:
	var e:Enemy=enemies.pick_random().instantiate()
	e.player=player
	add_sibling(e)
	
	e.global_position=$spawnpoint.global_position
	#$spawn_timer.wait_time-=0.1
	pass # Replace with function body.
