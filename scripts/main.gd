extends Node2D

# ⬅️ Precargar selectores 
@onready var sun_selector := $sun_sprite
@onready var mercury_selector := $mercury_sprite
@onready var venus_selector := $venus_sprite
@onready var earth_selector := $earth_sprite
@onready var mars_selector := $mars_sprite

@onready var camera_selector : Camera2D = $sun_sprite/CameraController.camera
@onready var info_selector := $UI/info

# ☀️ Instanciar objetos
@export var sun = CelesBody.new()
@export var mercury = CelesBody.new()
@export var venus = CelesBody.new()
@export var earth = CelesBody.new()
@export var mars = CelesBody.new()

# 🌠 Render Trayectoria
const MAX_STEPS = 177
var positions_history : Array[Array] = []
var sun_history : Array
var actual_index = 0

# 🆘 Auxiliares
const SCALED_DELTA = 0.1
var frame_counter = 0
var colors : Array[Color]

func _ready():
	# ⚠️ Limitar los FPS
	Engine.max_fps = 60
	
	# ☀️ Inicializar los sprites en base a la instancia
	sun.upload(sun_selector)
	mercury.upload(mercury_selector, sun_selector)
	venus.upload(venus_selector, sun_selector)
	earth.upload(earth_selector, sun_selector)
	mars.upload(mars_selector, sun_selector)
	
	colors = [
		sun.modulate,
		mercury.modulate,
		venus.modulate,
		earth.modulate,
		mars.modulate,
	]
		
	# 🌠 Inicializar los vectores de las trayectorias
	for i in range(MAX_STEPS):
		positions_history.append([
			mercury_selector.position,
			venus_selector.position,
			earth_selector.position,
			mars_selector.position
		])
		sun_history.append(sun_selector.position)



func _process(delta):
	# 🔢 Contador de frames
	frame_counter += 1
	
	# ➡️ Mover los sprites tras calcular la dinamica de la instancia
	sun.velocity = Vector2(1.32/7.39, 0)
	
	mercury.dinamize(mercury_selector, [sun, venus, earth, mars], SCALED_DELTA)
	venus.dinamize(venus_selector, [sun, mercury, earth, mars], SCALED_DELTA)
	earth.dinamize(earth_selector, [sun, mercury, venus, mars], SCALED_DELTA)
	mars.dinamize(mars_selector, [sun, mercury, venus, earth], SCALED_DELTA)
	sun.dinamize(sun_selector, null, SCALED_DELTA)
	
	$mName.global_position = mercury_selector.global_position
	$vName.global_position = venus_selector.global_position
	$eName.global_position = earth_selector.global_position
	$rName.global_position = mars_selector.global_position
	
	
	# 📍 Renderizar la trayectoria
	_update_path()
	queue_redraw()
	
	# 📅 Actualizar la interfaz
	if frame_counter % 15 == 0:
		_update_gui()
		frame_counter = 0


func _update_path():
	positions_history[actual_index][0] = mercury_selector.position
	positions_history[actual_index][1] = venus_selector.position
	positions_history[actual_index][2] = earth_selector.position
	positions_history[actual_index][3] = mars_selector.position
	
	sun_history[actual_index] = sun_selector.position
	
	actual_index = (actual_index + 1) % MAX_STEPS

func _update_gui():
	info_selector.text = """
		📅 Tiempo:  
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
	
	for pos in range(0, MAX_STEPS-1):
		indexFrom = (actual_index + pos) % MAX_STEPS
		indexTo = (actual_index + 1 + pos) % MAX_STEPS

		alpha = float(pos) / float(MAX_STEPS)
		
		draw_line(
			sun_history[indexFrom], 
			sun_history[indexTo], 
			Color(255,255,0,alpha)
		)
		
		for i in range(4):
			draw_line (
				positions_history[indexFrom][i], 
				positions_history[indexTo][i], 
				Color(
					colors[i+1].r,
					colors[i+1].g,
					colors[i+1].b,
					alpha,
					)
			)


func _on_camera_controller_attach_request() -> void:
	camera_selector.global_position = sun_selector.position
