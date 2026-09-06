extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/BotonJugar.pressed.connect(jugar)
	$CenterContainer/VBoxContainer/BotonSalir.pressed.connect(salir)
	$CenterContainer/VBoxContainer/BotonJugar.grab_focus()


func jugar() -> void:
	get_tree().change_scene_to_file("res://escenas/main_world/mapa.tscn")


func salir() -> void:
	get_tree().quit()
