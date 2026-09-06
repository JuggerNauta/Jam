extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/BotonReintentar.pressed.connect(reintentar)
	$CenterContainer/VBoxContainer/BotonMenu.pressed.connect(ir_al_menu)
	$CenterContainer/VBoxContainer/BotonReintentar.grab_focus()


func reintentar() -> void:
	get_tree().change_scene_to_file("res://escenas/main_world/mapa.tscn")


func ir_al_menu() -> void:
	get_tree().change_scene_to_file("res://escenas/main_world/menu_inicio.tscn")
