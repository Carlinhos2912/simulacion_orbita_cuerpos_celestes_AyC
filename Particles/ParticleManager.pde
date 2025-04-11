class ParticleManager {
  int amount;
  ArrayList<Particle> particles;

  ParticleManager() {
    particles = new ArrayList<Particle>();
  }

  void createParticles(int amount, Particle attractedTo) {
    this.amount = amount;

    for (int i = 0; i < amount; i++) {
      float radius = random(1, 3);
      float mass = random(1.65913e-07f, 3.00349e-06f);
      float posX = random(4, 84) * pow(-1, int(random(2))) + width/2;
      float posY = random(4, 84) * pow(-1, int(random(2))) + height/2;

      PVector position = new PVector(posX, posY);

      // Velocidad orbital inicial solo en dirección y
      float distance = PVector.dist(attractedTo.position, position);
      float vY = sqrt(Particle.GRAVITATORY * attractedTo.mass / distance) * Particle.VELOCITY_UNIT;
      PVector velocity = new PVector(0, vY);

      Particle particle = new Particle(position, velocity, mass, radius);

      particles.add(particle);

    }
  }
}
