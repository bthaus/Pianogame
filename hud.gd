extends CanvasLayer
class_name HUD
@export var piano:Piano
@export var player:PlayerCharacter
@onready var hp_bar:ProgressBar=%HPbar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	player.hp_changed.connect(update)
	pass # Replace with function body.
func update():
	hp_bar.max_value=player.max_hp
	hp_bar.value=player.hp
	$HPbar/max.text=str(player.max_hp)
	var t=1
	var color=remap(player.hp,0,player.max_hp,0,t)
	hp_bar.self_modulate=Color(t-color,color,0,t)
	
	var max_shield_hp=1
	var shield_hp=0
	for s in player.shields:
		max_shield_hp+=s.max_hp
		shield_hp+=s.hp
	$Shieldbar/max.text=str(max_shield_hp)
	$Shieldbar.max_value=max_shield_hp
	$Shieldbar.value=shield_hp	
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
