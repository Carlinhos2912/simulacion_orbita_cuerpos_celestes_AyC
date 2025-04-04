extends Node2D
class_name CameraController

@onready var camera : Camera2D = $Camera2D
signal attach_request
var isDragging = false

# 🎮 Metodo que, en base una accion de raton, modifica la camara
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and isDragging:
		global_position -= 3*(event.relative)/4
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isDragging = event.pressed
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(0.05, 0.05)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(0.05, 0.05)
			
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			attach_request.emit()
