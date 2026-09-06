extends Control

## Escena del mapa a la que se salta al pulsar "Jugar".
const ESCENA_MAPA := "res://escenas/main_world/mapa.tscn"


func _ready() -> void:
	$CenterContainer/VBoxContainer/BotonJugar.grab_focus()


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file(ESCENA_MAPA)


func _on_boton_salir_pressed() -> void:
	get_tree().quit()
