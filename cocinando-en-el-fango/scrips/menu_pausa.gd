extends CanvasLayer

const BUS_MASTER := 0

@onready var boton_pausa: Button = $BotonPausa
@onready var panel: Control = $Panel
@onready var boton_reanudar: Button = $Panel/CenterContainer/VBoxContainer/BotonReanudar
@onready var boton_menu: Button = $Panel/CenterContainer/VBoxContainer/BotonMenu
@onready var slider_volumen: HSlider = $Panel/CenterContainer/VBoxContainer/Volumen/Slider


func _ready() -> void:
	boton_pausa.pressed.connect(pausar)
	boton_reanudar.pressed.connect(reanudar)
	boton_menu.pressed.connect(ir_al_menu)
	slider_volumen.value_changed.connect(_on_volumen_cambiado)
	slider_volumen.value = db_to_linear(AudioServer.get_bus_volume_db(BUS_MASTER))
	panel.hide()


func pausar() -> void:
	get_tree().paused = true
	panel.show()
	boton_pausa.hide()


func reanudar() -> void:
	get_tree().paused = false
	panel.hide()
	boton_pausa.show()


func ir_al_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/main_world/menu_inicio.tscn")


func _on_volumen_cambiado(valor: float) -> void:
	AudioServer.set_bus_volume_db(BUS_MASTER, linear_to_db(valor))
