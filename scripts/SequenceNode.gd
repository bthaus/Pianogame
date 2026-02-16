extends Node
class_name SequenceNode

var incoming_edge: SequenceEdge
var outgoing_edge: SequenceEdge
@export var activating: bool
@export var next: Array[SequenceNode]
@export var max_delay_from_start: float
@export var min_delay_from_start: float
@export var spell: String
