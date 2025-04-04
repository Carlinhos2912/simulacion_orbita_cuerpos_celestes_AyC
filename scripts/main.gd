extends Node2D

# ⬅️ Precargar selectores 
@onready var sun_selector := $sun_sprite
@onready var earth_selector := $earth_sprite
@onready var camera_selector : Camera2D = $sun_sprite/CameraController.camera
@onready var info_selector := $UI/info

# ☀️ Instanciar objetos
@export var sun = CelesBody.new()
@export var earth = CelesBody.new()

# 🌠 Render Trayectoria
const MAX_STEPS = 255
var positions_history : Array
var sun_history : Array
var actual_index = 0

# 🆘 Auxiliares
const SCALED_DELTA = 0.075
var frame_counter = 0

func _ready():
	# ⚠️ Limitar los FPS
	Engine.max_fps = 60
	
	# ☀️ Inicializar los sprites en base a la instancia
	sun.upload(sun_selector)
	earth.upload(earth_selector, sun_selector)
	earth_selector.position = earth.position*Global.GAME_UNIT
	
	# 🌠 Inicializar los vectores de la trayectoria
	positions_history.resize(MAX_STEPS)
	sun_history.resize(MAX_STEPS)
	
	for i in range(MAX_STEPS):
		positions_history[i] = earth_selector.position
		sun_history[i] = sun_selector.position


func _process(delta):
	# 🔢 Contador de frames
	frame_counter += 1
	
	# ➡️ Mover los sprites tras calcular la dinamica de la instancia
	sun.acceleration = Vector2(1e-5, 0) 
	earth.dinamize(earth_selector, sun, SCALED_DELTA)
	sun.dinamize(sun_selector)
	
	# 📍 Renderizar la trayectoria
	_update_path()
	queue_redraw()
	
	# 📅 Actualizar la interfaz
	if frame_counter % 15 == 0:
		_update_gui()
		frame_counter = 0


func _update_path():
	positions_history[actual_index] = earth_selector.position
	sun_history[actual_index] = sun_selector.position
	
	actual_index = (actual_index + 1) % MAX_STEPS

func _update_gui():
	info_selector.text = """
		FPS: %s
		🌎 Radius: %s
		🌎 Position: %s
		🌎 Velocity: %s
		🌎 Acceleration: %s
		☀️ Radius: %s
		☀️ Position: %s
		☀️ Velocity: %s
		☀️ Acceleration: %s
		""" % [
			Engine.get_frames_per_second(),
			earth_selector.scale,
			earth.position,
			earth.velocity,
			earth.acceleration,
			
			sun_selector.scale,
			sun.position.round(),
			sun.velocity,
			sun.acceleration,
			
		]

func _draw():	
	var alpha : float
	var indexFrom : int
	var indexTo   : int
	
	for pos in range(MAX_STEPS-1):
		indexFrom = (actual_index + pos) % MAX_STEPS
		indexTo = (actual_index + 1 + pos) % MAX_STEPS

		alpha = float(pos) / float(MAX_STEPS)
		draw_line (
			positions_history[indexFrom], 
			positions_history[indexTo], 
			Color(175,175,175,alpha)
		)
		draw_line(
			sun_history[indexFrom], 
			sun_history[indexTo], 
			Color(255,255,0,alpha)
		)

func _on_camera_controller_attach_request() -> void:
	camera_selector.global_position = sun_selector.position
