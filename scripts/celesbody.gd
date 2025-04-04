extends Resource
class_name CelesBody

#Parámetros del cuerpo celeste (Discretos)
@export var modulate : Color
@export var visual : CompressedTexture2D

#Parámetros del cuerpo celeste (Numéricas Intrínsecas)
@export var raw_radius : String
@export var raw_mass : String
var radius : float
var mass : float

#Parámetros del cuerpo celeste (Numéricas Dinámicas)
@export var position : Vector2
@export var velocity : Vector2
@export var acceleration : Vector2
	

# ============================ * ECUACIONES FUNDAMENTALES * ============================
# ♻️ Metodo que actualiza un selector especificado en base a los parametros del CelesBody
func upload( selector : Sprite2D, size_relative_to : Sprite2D = null ):
	radius = float(self.raw_radius) if self.raw_radius.is_valid_float() else 0.0
	mass = float(self.raw_mass) if self.raw_mass.is_valid_float() else 0.0
	
	selector.texture = self.visual
	selector.self_modulate = self.modulate
	selector.position = self.position * Global.GAME_UNIT
	
	if size_relative_to:
		selector.scale = (Vector2(log(radius + 1), log(radius + 1)) * Global.GAME_UNIT)/size_relative_to.scale
	else:
		selector.scale = Vector2(log(radius + 1), log(radius + 1)) * Global.GAME_UNIT


# 🐊 Metodo que moviliza un selector segun calculos matematicos
func dinamize( selector : Sprite2D, respect : CelesBody = null, scale : float = 1.0, ):
	if respect:
		self.acceleration = self.calc_orbital_acceleration(respect.mass, respect.position)
	
	self.velocity += self.acceleration * scale
	self.position += self.velocity * scale
	
	selector.position = self.position * Global.GAME_UNIT


# 💫 Metodo que calcula la aceleracion orbital en base un objetivo
func calc_orbital_acceleration(objective_mass, objective_position: Vector2) -> Vector2:
	var r_vec = objective_position - self.position
	var acceleration_magnitude = Global.GRAVITATORY * objective_mass / r_vec.length_squared()
			
	# print("r_vec:", r_vec)
	# print("direction:", direction)
	# print("GRAVITATORY:", Global.GRAVITATORY)
	# print("objective_mass:", objective_mass)
	# print("length_squared:", r_vec.length_squared())
	# print("acceleration_magnitude:", acceleration_magnitude)
	# print("return:", direction * acceleration_magnitude)
	
	return r_vec.normalized() * acceleration_magnitude * Global.VELOCITY_UNIT
