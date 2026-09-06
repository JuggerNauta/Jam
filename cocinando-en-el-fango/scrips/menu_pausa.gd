extends CanvasLayer


func _ready() -> void:
	$BotonPausa.pressed.connect(pausar)
	$Panel/CenterContainer/VBoxContainer/BotonReanudar.pressed.connect(reanudar)
	$Panel/CenterContainer/VBoxContainer/BotonMenu.pressed.connect(ir_al_menu)
	$Panel.hide()


func pausar() -> void:
	get_tree().paused = true
	$Panel.show()
	$BotonPausa.hide()


func reanudar() -> void:
	get_tree().paused = false
	$Panel.hide()
	$BotonPausa.show()


func ir_al_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/main_world/menu_inicio.tscn")
