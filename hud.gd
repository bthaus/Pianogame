extends CanvasLayer
class_name HUD
@export var piano:Piano
@export var player:PlayerCharacter
@onready var hp_bar:ProgressBar=%HPbar
@onready var visual_piano=$Piano2
@export var visual_piano_opt_on:bool
var beat:Beat
var game_piano_size=Vector2(1098,136)
var game_piano_position=Vector2(408,314)
# Called when the node enters the scene tree for the first time.
func hide_player_stats():
	%HPbar.hide()
	%Shieldbar.hide()
	$errors.hide()
	$heals.hide()
	pass;
func _ready() -> void:
	show()
	if not visual_piano_opt_on:
		visual_piano.position=game_piano_position
	#	visual_piano.scale=game_piano_size
	else:
		visual_piano.show()
	player.hp_changed.connect(update)
	beat=Beat.get_beat_instance()
	pass # Replace with function body.
func toggle_piano(on):
	if visual_piano_opt_on:return 
	visual_piano.visible=on	
func update():
	$errors.text=str(player.piano.number_of_errors_unstarted)
	hp_bar.max_value=player.max_hp
	hp_bar.value=player.hp
	$HPbar/max.text=str(player.max_hp)
	var t=1
	var color=remap(player.hp,0,player.max_hp,0,t)
	hp_bar.self_modulate=Color(t-color,color,0,t)
	$heals.text="+"+str(player.heals)
	var max_shield_hp=1
	var shield_hp=0
	for s in player.shields:
		if not is_instance_valid(s):continue
		max_shield_hp+=s.max_hp
		shield_hp+=s.hp
	$Shieldbar/max.text=str(max_shield_hp)
	$Shieldbar.max_value=max_shield_hp
	$Shieldbar.value=shield_hp	
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
