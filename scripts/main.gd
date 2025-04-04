extends Node2D

#Instancia de sprites y CelesBody
@onready var sun_selector = $sun_sprite
@onready var earth_selector = $earth_sprite
@onready var camera_selector = $sun_sprite/camara

@export var sun = CelesBody.new()
@export var earth = CelesBody.new()

var positions_history : Array
var sun_history : Array


func _ready():
	#Inicialización de sol (0,0)
	sun.position = Vector2(get_viewport_rect().size / Vector2(2,2))
	
	sun_selector.texture = sun.visual
	sun_selector.self_modulate = sun.modulate
	sun_selector.scale = Vector2(sun.radius * 0.001, sun.radius * 0.001)
	sun_selector.position = sun.position
	
	earth_selector.texture = earth.visual
	earth_selector.self_modulate = earth.modulate
	earth_selector.scale = Vector2(earth.radius * 0.001,  earth.radius * 0.001)
	
	earth.position = sun.position +  earth.position
	earth_selector.position = earth.position
	
#	print(earth.modulate)
# 	print("Ola ya cargué")

func _process(delta):	
	positions_history.append(earth.position)
	sun_history.append(sun.position)
	earth.distance = Vector2(earth.position).distance_to(sun.position)
	earth.acceleration = earth.calc_orbital_acceleration(sun.SUN_MASS, sun.position)
	
#	print("delta", delta)
	earth.velocity += earth.acceleration * 0.01 * delta
	earth.position += earth.velocity * 0.01 * delta
	earth_selector.position = earth.position
	earth_selector.rotation += 0.01
	
	sun.velocity = Vector2(720000000000 * sun.SCALE_FACTOR, 0)
	sun.position += sun.velocity * 0.01 * delta
	sun_selector.position = sun.position
	camera_selector.position = sun.position
	print(camera_selector.position, sun.position)
	queue_redraw()

func _draw():
	if len(positions_history) > 500:
		positions_history = positions_history.slice(-100, -1, 1)

	for pos in range(1,len(positions_history)):
		draw_line(positions_history[pos-1], positions_history[pos],  Color(175,175,175,pos/500), 1, true)
		draw_line(sun_history[pos-1], sun_history[pos], Color(255,255,0,pos/500), 1, true)
		
