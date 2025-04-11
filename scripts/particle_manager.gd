extends Node
class_name ParticleManager

var amount : int
var particles : Array[CelesBody]

func create_particles(amount, atracted_to : CelesBody):
	self.amount = amount
	for i in range(amount):
		self.particles.append(CelesBody.new())
		self.particles[i].radius = randf_range(5, 26)
		self.particles[i].mass = randf_range( 1.65913e-07, 3.00349e-06 )
		self.particles[i].position = Vector2(randf_range(2, 84)*(-1)**randi(), randf_range(2, 84)*(-1)**randi())
		
		self.particles[i].velocity = Vector2( 
			0, sqrt(
			  (Global.GRAVITATORY*atracted_to.mass)/
			  atracted_to.position.distance_to(self.particles[i].position
			)))
		
		print(i, self.particles[i])
