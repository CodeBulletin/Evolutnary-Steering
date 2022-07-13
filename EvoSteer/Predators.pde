class Predators {
  float r, PreceptionRadius, aRad;
  float MaxForceMag, MaxSpeedMag;
  PVector Velocity, Acc, pos;
  Predators(PVector _pos, PVector _vel, float _r, float _PR, float _aRad) {
    pos = _pos;
    Velocity = _vel;
    r = _r;
    PreceptionRadius = _PR;
    MaxForceMag = MaxAccP;
    MaxSpeedMag = MaxSpeedP;
    Acc = new PVector(0, 0);
    Velocity.setMag(MaxSpeed);
    aRad = _aRad;
  }
  void behaviour(ArrayList<Prey> list, ArrayList<Predators> list2) {
    PVector PreyForce = eat(list);
    PVector Dontcrowd = DontCrowd(list2);
    PVector boundSteer = boundaries();
    applyforce(PreyForce);
    applyforce(Dontcrowd);
    applyforce(boundSteer);
  }
  PVector eat(ArrayList<Prey> list) {
    float record = 10*width;
    PVector closest = null;
    for (int i = list.size()-1; i >= 0; i--) {
      float d = pos.dist(list.get(i).pos);
      if (d < MaxSpeedMag) {
        list.remove(list.get(i));
      } else if (d < record && d < PreceptionRadius/2) {
        record = d;
        closest = list.get(i).pos;
      }
    }
    if (closest != null) {
      return seek(closest);
    }
    return new PVector(0, 0);
  }
  PVector DontCrowd(ArrayList<Predators> list){
    float record = 10*width;
    PVector closest = null;
    
    for (int i = list.size()-1; i >= 0; i--) {
      float d = pos.dist(list.get(i).pos);
      if (d < record && d < aRad/2 && list.get(i) != this) {
        record = d;
        closest = list.get(i).pos;
      }
    }
    if (closest != null) {
      PVector P = seek(closest);
      P.mult(-3);
      return P;
    }
    return new PVector(0, 0);
  }
  void show() {
    push();
    float angle = Velocity.heading();
    translate(pos.x, pos.y);
    rotate(angle);
    color c = color(255, 0, 255);
    fill(c);
    stroke(c);
    if (debug) {
      push();
      noFill();
      ellipse(0, 0, PreceptionRadius, PreceptionRadius);
      stroke(255, 255, 255);
      ellipse(0, 0, aRad, aRad);
      pop();
    }
    rect(0, 0, r*2, r);
    triangle(r, -r/2, r, r/2, 2*r, 0);
    pop();
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
  void update() {
    Acc.limit(MaxForceMag);
    Velocity.add(Acc);
    Velocity.limit(MaxSpeedMag);
    pos.add(Velocity);
    Acc.mult(0);
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
