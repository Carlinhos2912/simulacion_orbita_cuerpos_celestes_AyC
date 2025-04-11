
class Particle {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float radius;
    float mass;
    
    static final float GRAVITATORY = 0.002959122083;    // Ajusta según necesidad
    static final float UA_M = 1.496e11;
    static final float DIST_UNIT = UA_M / 100;
    static final float TIME_UNIT = 86400;
    static final float VELOCITY_UNIT = DIST_UNIT / TIME_UNIT;  // Ajusta según necesidad
    static final float SCALE_FACTOR = DIST_UNIT;
    
    Particle(PVector pos, PVector vel, float m, float radius) {
        position = pos.copy();
        velocity = vel.copy();
        acceleration = new PVector(0, 0);
        mass = m;
        this.radius = radius;
    }
    
    void dinamize(Object respect, float scale, boolean verlet) {
        if (respect != null) {
            acceleration = calcOrbitalAcceleration(respect);
        }
        
        if (verlet) {
            PVector newPos = PVector.add(position, PVector.add(PVector.mult(velocity, scale), PVector.mult(acceleration, 0.5f * scale * scale)));
            PVector newAcceleration = new PVector(0, 0);
            if (respect != null) {
                position = newPos.copy();
                newAcceleration = calcOrbitalAcceleration(respect);
            }
            velocity.add(PVector.mult(PVector.add(acceleration, newAcceleration), 0.5f * scale * Particle.VELOCITY_UNIT));
            position = newPos.copy();
        } else {
            velocity.add(PVector.mult(acceleration, scale * Particle.VELOCITY_UNIT));
            position.add(PVector.mult(velocity, scale));
        }
    }
    
    PVector calcOrbitalAcceleration(Object objective) {
        if (objective == null) {
            return new PVector(0, 0);
        }
        
        if (objective instanceof Particle) {
            Particle obj = (Particle) objective;
            PVector rVec = PVector.sub(obj.position, position);
            float rSq = rVec.magSq();
            if (rSq == 0) return new PVector(0, 0);  // Para evitar división por cero
            float accMag = GRAVITATORY * obj.mass / rSq;
            return rVec.copy().normalize().mult(accMag * VELOCITY_UNIT);
        }
        
        if (objective instanceof ArrayList <? >) {
            ArrayList<?> list = (ArrayList<?> ) objective;
            if (list.isEmpty()) return new PVector(0, 0);
            
            PVector first = calcOrbitalAcceleration(list.get(0));
            ArrayList<Object> rest = new ArrayList<Object>(list.subList(1, list.size()));
            return PVector.add(first, calcOrbitalAcceleration(rest));
        }
        
        return new PVector(0, 0);
    }
    
    void display(color c) {
        fill(c);
        noStroke();
        ellipse(position.x, position.y, radius * 2, radius * 2);
    }
}
