extends Node

signal cambio(indice: int)

var indice := 0

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	if event.keycode >= KEY_1 and event.keycode <= KEY_6:
		indice = event.keycode - KEY_1
		cambio.emit(indice)
	elif event.keycode == KEY_Q:
		Inventario.soltar_objeto(indice)
