class Rectangle {
    
    float x, y, w, h;
    
    Rectangle(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
    boolean contains(Particle particle) {
        return(particle.position.x >= this.x - this.w && 
            particle.position.y >= this.y - this.h && 
            particle.position.x <= this.x + this.w && 
            particle.position.y <= this.y + this.h);
    }
}

class QuadTree {
    
    Rectangle boundary;
    int capacity;
    ArrayList<Particle> particles;
    boolean divided;
    QuadTree northeast;
    QuadTree southeast;
    QuadTree northwest;
    QuadTree southwest;
    Particle atractedTo;
    
    QuadTree(Rectangle bounds, int cap, Particle atr) {
        this.boundary = bounds;
        this.capacity = cap;
        this.particles = new ArrayList<Particle>();
        this.divided = false;
        this.atractedTo = atr;
    }
    
    void subdivide() {
        float x = this.boundary.x;
        float y = this.boundary.y;
        float w = this.boundary.w / 2;
        float h = this.boundary.h / 2;
        Rectangle ne = new Rectangle(x + w, y - h, w, h);
        this.northeast = new QuadTree(ne, this.capacity,this.atractedTo);
        Rectangle nw = new Rectangle(x - w, y - h, w, h);
        this.northwest = new QuadTree(nw, this.capacity, this.atractedTo);
        Rectangle se = new Rectangle(x + w, y + h, w, h);
        this.southeast = new QuadTree(se, this.capacity, this.atractedTo);
        Rectangle sw = new Rectangle(x - w, y + h, w, h);
        this.southwest = new QuadTree(sw, this.capacity, this.atractedTo);
        this.divided = true;
    }
    
    void insert(Particle particle) {
        if (!this.boundary.contains(particle)) {
            return;
        }
        if (this.particles.size() < this.capacity) {
            this.particles.add(particle);
        } else {
            if (!this.divided) {
                this.subdivide();
                for (Particle element : this.particles) {
                    this.northwest.insert(element);
                    this.northeast.insert(element);
                    this.southwest.insert(element);
                    this.southeast.insert(element);
                }
            }
            this.northwest.insert(particle);
            this.northeast.insert(particle);
            this.southwest.insert(particle);
            this.southeast.insert(particle);
            
        }
    }
    
    void dinamize(float scale, boolean verlet) {
        if (this.divided) {
            this.northwest.dinamize(scale, verlet);
            this.northeast.dinamize(scale, verlet);
            this.southwest.dinamize(scale, verlet);
            this.southeast.dinamize(scale, verlet);
        } else {
            ArrayList<Particle> objectives = (ArrayList)this.particles.clone();
            objectives.add(this.atractedTo);
            for (Particle particle : this.particles) {
                particle.dinamize(objectives, scale, verlet);
            }
        }
    }
    
}
