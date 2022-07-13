class Prey {
  PVector Velocity, Acc, pos;
  int health;
  float r;
  float MaxForceMag, MaxSpeedMag;
  Genotype gene;
  boolean repu;
  Prey(PVector _pos, PVector _vel, float _r, int _health) {
    gene = new Genotype();
    pos = _pos;
    r = _r;
    health = _health;
    MaxForceMag = MaxAcc;
    MaxSpeedMag = MaxSpeed;
    Acc = new PVector(0, 0);
    _vel.setMag(MaxSpeedMag);
    Velocity = _vel;
    repu = true;
  }

  Prey(Genotype _gene, PVector _pos, PVector _vel, float _r, int _health) {
    gene = _gene;
    pos = _pos;
    Velocity = _vel;
    r = _r;
    health = _health;
    MaxForceMag = MaxAcc;
    MaxSpeedMag = MaxSpeed;
    Acc = new PVector(0, 0);
    Velocity.setMag(MaxSpeed);
    repu = false;
  }

  void behaviour() {
    Circle c1 = new Circle(pos.x, pos.y, max(max(gene.dna[3], gene.dna[4], gene.dna[5]), gene.dna[6])); 
    ArrayList<Point> points = qt.query(c1, null);
    Prey g = reproduce(points);
    if (g != null) {
      Agents.add(g);
    }
    PVector foodSteer = eat(points, foodvalue, gene.dna[3], true);
    PVector poisonSteer = eat(points, -poisonvalue, gene.dna[4], false);
    ArrayList<PVector> avoidpredator = avoidPredator(points);
    PVector boundSteer = boundaries();
    foodSteer.mult(gene.dna[0]);
    poisonSteer.mult(gene.dna[1]);
    applyforce(foodSteer);
    applyforce(poisonSteer);
    for (PVector PX : avoidpredator) {
      applyforce(PX);
    }
    applyforce(boundSteer);
  }

  Prey reproduce(ArrayList<Point> list) {
    boolean successful = false;
    if (repu && health > Min_foodRequired_forReproduction) {
      Genotype nGene = null;
      PVector Npos = null;
      for (int i = 0; i < list.size(); i++) {
        Point po = list.get(i);
        if (po.P3 != null) {
          Prey other = po.P3;
          if (isnearme(other)){
            if (random(1) < Sexual_Reproduction_chances) {
              successful = true;
              repu = false;
              nGene = other.gene.copy();
              Npos = other.pos;
              other.repu = false;
              break;
            }
          }
        }
      }
      if (successful) {
        nGene = nGene.crossover(gene);
        nGene.mutate(3);
        Npos = new PVector((pos.x + Npos.x)/2, (pos.y + Npos.y)/2);
        health -= sex_cost;
        Prey MyPrey = new Prey(nGene, Npos, PVector.random2D(), r, healthLimit);
        MyPrey.repu = false;
        return MyPrey;
      }
    }
    if (random(1) < Asexual_Reproduction_chances && health > Min_foodRequired_forReproduction && !successful) {
      Genotype newGene = gene.copy();
      newGene.mutate(3);
      health -= asex_cost;
      return new Prey(newGene, pos.copy(), PVector.random2D(), r, health);
    } else {
      return null;
    }
  }
  boolean isnearme(Prey p) {
    return (pos.dist(p.pos) < gene.dna[5]/2);
  }
  PVector boundaries() {
    float r = this.r*2;
    PVector desired = null;
    if (this.pos.x < r) {
      desired = new PVector(MaxSpeedMag, Velocity.y);
    } else if (this.pos.x > width - r) {
      desired = new PVector(-MaxSpeedMag, Velocity.y);
    }
    if (this.pos.y < r) {
      desired = new PVector(Velocity.x, MaxSpeedMag);
    } else if (this.pos.y > height - r) {
      desired = new PVector(Velocity.x, -MaxSpeedMag);
    }
    if (desired != null) {
      desired.setMag(3*MaxSpeedMag);
      PVector steer = PVector.sub(desired, Velocity);
      steer.setMag(10*MaxForceMag);
      return steer;
    }
    return new PVector(0, 0);
  }

  ArrayList<PVector> avoidPredator(ArrayList<Point> list) {
    ArrayList<PVector> allPForces = new ArrayList<PVector>();
    for (Point p: list) {
      if (p.P4 != null) {
        Predators P = p.P4;
        if (pos.dist(P.pos) < gene.dna[6]/2) {
          PVector PX = seek(P.pos);
          PX.mult(3*gene.dna[2]);
          allPForces.add(PX);
        }
      }
    }
    return allPForces;
  }

  boolean dead() {
    return health < 0;
  }

  PVector eat(ArrayList<Point> list, int t, float perception, boolean isFood) {
    float record = 10*width;
    PVector closest = null;
    for (int i = list.size()-1; i >= 0; i--) {
      Point po = list.get(i);
      if ((po.P1 != null && isFood)||(po.P2 != null && !isFood)) {
        PVector other = po.P1 !=null?po.P1:po.P2;
        float d = pos.dist(other);
        if (d < MaxSpeedMag) {
          if (isFood) {
            food.remove(other);
          } else {
            poison.remove(other);
          }
          health += t;
          if (health > healthLimit) {
            health = healthLimit;
          }
        } else if (d < record && d < perception/2) {
          record = d;
          closest = other;
        }
      }
    }
    if (closest != null) {
      return seek(closest);
    }
    return new PVector(0, 0);
  }
  void show() {
    push();
    float angle = Velocity.heading();
    translate(pos.x, pos.y);
    rotate(angle);
    if (debug) {
      noFill();
      stroke(0, 255, 0);
      line(0, 0, 20*map(gene.dna[0], 0, 5, 1, 5), 0);
      ellipse(0, 0, gene.dna[3], gene.dna[3]);
      stroke(255, 0, 0);
      line(0, 0, 20*map(gene.dna[1], -5, 0, -5, -1), 0);
      ellipse(0, 0, gene.dna[4], gene.dna[4]);
      stroke(255, 0, 255);
      line(0, 0, 20*map(gene.dna[2], -5, 0, -5, -1), 10);
      line(0, 0, 20*map(gene.dna[2], -5, 0, -5, -1), -10);
      ellipse(0, 0, gene.dna[6], gene.dna[6]);
      stroke(255, 255, 0);
      ellipse(0, 0, gene.dna[5], gene.dna[5]);
    }
    color c = lerpColor(color(255, 0, 0), color(0, 255, 0), map(health, 0, healthLimit, 0, 1));
    fill(c);
    stroke(c);
    rect(0, 0, r*2, r);
    triangle(r, -r/2, r, r/2, 2*r, 0);
    pop();
  }
  void update() {
    health-=health_redu;
    Acc.limit(MaxForceMag);
    Velocity.add(Acc);
    Velocity.limit(MaxSpeedMag);
    pos.add(Velocity);
    Acc.mult(0);
    if (!repu && random(1) < sex_regain) {
      repu = true;
    }
  }
  void applyforce(PVector acc) {
    Acc.add(acc);
  }
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(MaxSpeedMag);
    PVector steer = PVector.sub(desired, Velocity);
    return steer;
  }
}
