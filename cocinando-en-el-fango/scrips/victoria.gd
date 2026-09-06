extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/BotonJugarDeNuevo.pressed.connect(jugar_de_nuevo)
	$CenterContainer/VBoxContainer/BotonMenu.pressed.connect(ir_al_menu)
	$CenterContainer/VBoxContainer/BotonJugarDeNuevo.grab_focus()


func jugar_de_nuevo() -> void:
	get_tree().change_scene_to_file("res://escenas/main_world/mapa.tscn")


func ir_al_menu() -> void:
	get_tree().change_scene_to_file("res://escenas/main_world/menu_inicio.tscn")
