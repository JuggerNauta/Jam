extends Node

var tiempo: float = 600

var tiempoText = ""

@onready var label = $Control/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tiempo -= delta
	
	var minutos = int(tiempo / 60)
	var segundos = int(tiempo) % 60
	tiempoText =  str(minutos,":",segundos)
	
	label.text = tiempoText
	pass
