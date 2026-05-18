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
	var t=1
	var color=remap(player.hp,0,player.max_hp,0,t)
	hp_bar.self_modulate=Color(t-color,color,0,t)
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
