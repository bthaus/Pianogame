extends Node2D
class_name SpellCreator
@export var key_controller:KeyController
static var spell_names = {
	"Red": {
		"prefix": [
			"Ignis", "Pyra", "Flamma", "Cindar", "Blazus",
			"Volkar", "Ember", "Scorch", "Sola", "Brim",
			"Infern", "Caldris", "Fyrn", "Ashen", "Pyros",
			"Kindle", "Branzor", "Heatra", "Sulfar", "Magnar"
		],
		"suffix": [
			"flare", "burnus", "inferno", "ash", "spark",
			"pyrium", "vulcan", "cinder", "flamex", "char",
			"ember", "blaze", "scorch", "combust", "ignition",
			"flarex", "burna", "heatwave", "pyre", "smolder"
		]
	},"Green": {
	"prefix": [
		"Verdan", "Sylva", "Thorn", "Briar", "Oaken",
		"Wildra", "Mossen", "Fernis", "Blooma", "Rootar",
		"Druida", "Willow", "Bramble", "Grove", "Cedar",
		"Vinea", "Petala", "Sprout", "Yarrow", "Elder"
	],

	"suffix": [
		"bloom", "root", "vine", "thorn", "grove",
		"leaf", "bark", "seed", "petal", "canopy",
		"wilds", "growth", "bramble", "sprout", "blossom",
		"wood", "forest", "verdure", "thicket", "wreath"
	]
},

	"Blue": {
		"prefix": [
			"Glacius", "Frost", "Cryo", "Haila", "Nivus",
			"Winter", "Shivra", "Boreal", "Chill", "Frigus",
			"Avalis", "Gelid", "Snowra", "Hailen", "Permaf",
			"Icelyn", "Vitrus", "Coldra", "Blizzar", "Skadi"
		],
		"suffix": [
			"shard", "freeze", "glacia", "snow", "ice",
			"blight", "frostus", "veil", "crystal", "cold",
			"hail", "permafrost", "glint", "shiver", "whiteout",
			"icicle", "frostbite", "glacier", "winter", "drift"
		]
	},

	"Yellow": {
		"prefix": [
			"Voltus", "Zappo", "Thundra", "Fulmin", "Sparkus",
			"Storma", "Electro", "Zephy", "Arka", "Stormix",
			"Voltra", "Keraun", "Aether", "Luxor", "Zapris",
			"Bront", "Strika", "Tesla", "Ionis", "Skylor"
		],
		"suffix": [
			"bolt", "shock", "storm", "arc", "zap",
			"current", "flash", "spark", "surge", "stormus",
			"voltage", "discharge", "strike", "chain", "pulse",
			"static", "thunder", "ripple", "jolt", "conduit"
		]
	},
	"White":{
		"prefix": [
		"Arcan", "Nulla", "Eldrin", "Mystral", "Runic",
		"Obscur", "Vantus", "Chrona", "Astral", "Umbris",
		"Sigil", "Nexar", "Lorein", "Virel", "Aurum",
		"Voidra", "Paradox", "Glyphic", "Hexar", "Syntar",
		"Monolith", "Echra", "Luxan", "Morphan", "Kairon"
	],

	"suffix": [
		"weave", "glyph", "sigil", "rift", "veil",
		"echo", "matrix", "form", "bound", "thread",
		"pulse", "mark", "cipher", "shade", "aura",
		"fragment", "node", "essence", "loop", "flux",
		"orbit", "resonance", "trace", "hollow", "core"
	]
	}
}
static var spell_components={
	"White"=[load('res://scene/SpellComponents/fireball.tscn')],
	"Red"=[load('res://scene/SpellComponents/missile.tscn')],
	"Green"=[load('res://scene/SpellComponents/doubleshot.tscn')],
	"Blue"=[load('res://scene/SpellComponents/freezebolt.tscn')],
	"Yellow"=[load('res://scene/SpellComponents/backshot.tscn')]
}
static func get_spell_component(color:String):
	return spell_components[color].pick_random()
	pass
static func get_new_spell_name(color:String):
	var prefix=spell_names[color]["prefix"]
	var suffix=spell_names[color]["suffix"]
	return prefix.pick_random()+" "+suffix.pick_random()
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_controller.key_pressed.connect(register_key_press)
	pass # Replace with function body.

var keys:Array[PianoEvent]=[]

func register_key_press(event:PianoEvent):
	print(event.get_key())
	if event.get_key()=="B1":
		store_keys()
	var k=event.get_key()	
	if Piano.easy_move_keys.has(k) or Piano.quick_menu_keys.has(k) or Piano.menu_keys.has(k) or Piano.movement_keys.has(k):
		return
	keys.push_back(event)
	pass
func get_spell(color,spell_string="",spell_name=""):
	if spell_string=="":
		spell_string=store_keys()
	if spell_string==null:return
	var spell=Spell.new()
	spell.full_input=spell_string
	spell.parse_input()
	spell.component_for_all=get_spell_component(color)
	spell.set_comps()
	if spell_name=="":spell_name=get_new_spell_name(color)
	spell.spell_name=spell_name
	
	return spell
	pass	

static func get_spell_from_data(color,spell_string,spell_name):
	var spell=Spell.new()
	spell.full_input=spell_string
	spell.parse_input()
	spell.component_for_all=get_spell_component(color)
	spell.set_comps()
	if spell_name=="":spell_name=get_new_spell_name(color)
	spell.spell_name=spell_name
	
	return spell
	pass	
func store_keys():
	if keys.is_empty():return
	var first_timestamp=keys.front().timestamp
	var string=""
	for k:PianoEvent in keys:
		var off_time=k.timestamp-first_timestamp
		string+=str(off_time)+"+"+k.get_key()+"-"
		print(str(off_time)+"+"+k.get_key())
		print("-")
	keys.clear()	
	return string	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
