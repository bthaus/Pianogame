extends TileMapLayer
class_name Map
static var instance:TileMapLayer
static func get_map():
	return instance
	pass;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance=self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
