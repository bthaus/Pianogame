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
static func get_new_spell_name(color:String):
	var prefix=spell_names[color]["prefix"]
	var suffix=spell_names[color]["suffix"]
	return prefix+" "+suffix
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
	keys.push_back(event)
	pass
func store_keys():
	var first_timestamp=keys.front().timestamp
	for k:PianoEvent in keys:
		var off_time=k.timestamp-first_timestamp
		print(str(off_time)+"+"+k.get_key())
		print("-")
		
		
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
