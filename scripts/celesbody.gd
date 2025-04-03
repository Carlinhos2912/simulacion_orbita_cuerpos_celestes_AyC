extends Resource
class_name CelesBody

#Parámetros del cuerpo celeste (Discretos)
@export var name : String
@export var modulate : Color
@export var visual : CompressedTexture2D

#Parámetros del cuerpo celeste (Numéricos)
@export var radius : float
@export var position : Vector2 = Vector2(1 * UA * SCALE_FACTOR, 0)
@export var distance : float = Vector2(1 * UA * SCALE_FACTOR, 0).distance_to(Vector2(0,0))
@export var velocity : Vector2 = Vector2(0, 1.991 * 10 ** -4 * SCALE_FACTOR)
@export var acceleration : Vector2
@export var mass : float
@export var force : Vector2

#Constantes importantes
const UA = 149.6 * 10 ** 9
const SCALE_FACTOR = 250 / UA
const GRAVITATORY = 6.6743 * 10 ** -1.1
const SUN_MASS = 1.9890 * 10 ** 3
const EARTH_MASS = 5.9722 * 10 ** 2.4

#=================== ECUACIONES FUNDAMENTALES ============================
func calc_graviatory_force(position: Vector2) -> Vector2:
	return Vector2(
		GRAVITATORY * SUN_MASS * self.mass / self.distance ** 2 * position.x,
		GRAVITATORY * SUN_MASS * self.mass / self.distance ** 2 * position.y
		 )

func calc_newton_force(mass, acceleration: Vector2):
	return Vector2(mass * acceleration.x, mass * acceleration.y)

func calc_orbital_acceleration(mass, position: Vector2) -> Vector2:
#	print("Direccion ", Vector2(self.position).direction_to(position))
#	print("Distancia al cuadrado ", Vector2(self.position).distance_squared_to(position))
#	print("Masa del sol ",mass)
#	print("Constante ",GRAVITATORY)
	print("MMGV: ", GRAVITATORY * mass / Vector2(self.position).distance_squared_to(position) * Vector2(self.position).direction_to(position))
#	return GRAVITATORY * mass / Vector2(self.position).distance_squared_to(position) * Vector2(self.position).direction_to(position)
	return Vector2(-2000000, -3000000)
