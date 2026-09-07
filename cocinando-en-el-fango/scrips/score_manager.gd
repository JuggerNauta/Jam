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
const ESCENA_VICTORIA := "res://escenas/victoria.tscn"

# utilizar esta funcion para agregar puntos , porfavor agarrala :D
func agregar_puntos(cantidad: int):
	puntaje += cantidad
	_updateText(puntaje)
	pass
	
func _updateText(cantidad: int):
	label.text = str(cantidad)
	puntaje_cambiado.emit(puntaje)
	
	if puntaje >= 100:
		get_tree().change_scene_to_file(ESCENA_VICTORIA)
		

func reiniciar():
	puntaje = 0
	_updateText(puntaje)
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_P:
		agregar_puntos(10)
	pass
	
	
