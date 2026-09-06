extends Area2D

@export var daño: int = 1
var ya_hizo_daño: bool = false


func _on_body_entered(cuerpo: Node2D) -> void:
	
	if ya_hizo_daño:
		return
	
	if cuerpo.is_in_group("jugador"):
		
		ya_hizo_daño = true
		
		cuerpo.recibir_daño(daño)
