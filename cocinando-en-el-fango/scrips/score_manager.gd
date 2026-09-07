extends Node

signal puntaje_cambiado(puntaje: int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@onready var label = $Control/Label

var puntaje: int = 0

# utilizar esta funcion para agregar puntos , porfavor agarrala :D
func agregar_puntos(cantidad: int):
	puntaje += cantidad
	_updateText(puntaje)
	pass
	
func _updateText(cantidad: int):
	label.text = cantidad
	puntaje_cambiado.emit(puntaje)

func reiniciar():
	puntaje = 0
	_updateText(puntaje)
	pass
	
	
