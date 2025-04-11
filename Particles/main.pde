Particle sun;
ParticleManager particleManager;
QuadTree quadTree;

void setup() {
    size(1152,648);
    sun = new Particle(new PVector(width / 2, height / 2), new PVector(0, 0), 2,10);
    particleManager = new ParticleManager();
    particleManager.createParticles(2000,sun);
    quadTree = new QuadTree(new Rectangle(0, 0, width, height), 10, sun);
    for (Particle particle : particleManager.particles) {
        quadTree.insert(particle);
    }
    
}

void draw() {
    background(0);
    quadTree.dinamize(0.01, true);
    for (Particle particle : particleManager.particles) {
        particle.display(color(255, 0, 0));
    }
    quadTree = new QuadTree(new Rectangle(0, 0, width, height), 4, sun);
    for (Particle particle : particleManager.particles) {
        quadTree.insert(particle);
    }
    
    sun.display(color(255, 100, 100));
}
