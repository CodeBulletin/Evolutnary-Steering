void setup() {
  fullScreen(P2D);
  width = width*2;
  height = height*2;
  fastmode(fastMode);
  rectMode(CENTER);
  world = new Rectangle(width/2, height/2, 2*width/3, 2*height/3);
  qt = new QuadTree(world, Perf_Factor);
  Agents = new ArrayList<Prey>();
  for (int i = 0; i < Starting_world_population; i++) {
    Agents.add(new Prey(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)), PVector.random2D(), size_of_bodies, StartingHealth));
  }
  Agents2 = new ArrayList<Predators>();
  for (int i = 0; i < Predator_pop; i++) {
    Agents2.add(new Predators(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)), PVector.random2D(), size_of_bodies, Predator_eye, Predator_repl));
  }
  food = new ArrayList<PVector>();
  for (int i = 0; i < Amount_of_food; i++) {
    food.add(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)));
  }
  poison = new ArrayList<PVector>();
  for (int i = 0; i < Amount_of_poison; i++) {
    poison.add(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)));
  }
}

void draw() {
  scale(0.5);
  background(0);
  noFill();
  stroke(255);
  rect(width/2, height/2, width-2*size_of_bodies, height-2*size_of_bodies);
  updateworld();
  noStroke();
  fill(0, 255, 0);
  for (PVector f : food) {
    Point P = new Point(f.x, f.y, f, true);
    qt.insert(P); 
    ellipse(f.x, f.y, 6, 6);
  }
  fill(255, 0, 0);
  for (PVector p : poison) {
    Point P = new Point(p.x, p.y, p, false);
    qt.insert(P); 
    ellipse(p.x, p.y, 6, 6);
  }
  for (Prey prey : Agents) {
    Point P = new Point(prey.pos.x, prey.pos.y, prey);
    qt.insert(P);
  }
  for (Predators predators : Agents2) {
    Point P = new Point(predators.pos.x, predators.pos.y, predators);
    qt.insert(P);
  }
  if (debug) {
    push();
    noFill();
    stroke(255);
    strokeWeight(2);
    qt.show();
    pop();
  }
  for (int i = Agents.size()-1; i >= 0; i--) {
    Agents.get(i).behaviour();
    Agents.get(i).show();
    Agents.get(i).update();
    if (Agents.get(i).dead()) {
      if (Agents.get(i).pos.x > 2*size_of_bodies && Agents.get(i).pos.x < width-2*size_of_bodies && Agents.get(i).pos.y > 2*size_of_bodies && Agents.get(i).pos.y < height-2*size_of_bodies) {
        food.add(new PVector(Agents.get(i).pos.x, Agents.get(i).pos.y));
      }
      Agents.remove(Agents.get(i));
    }
  }
  for (Predators now : Agents2) {
    now.behaviour();
    now.show();
    now.update();
  }
}

void updateworld() {
  qt.clear();
  if (random(1) < foodAdd) {
    food.add(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)));
  }
  if (random(1) < PoisonAdd) {
    poison.add(new PVector(random(2*size_of_bodies, width-2*size_of_bodies), random(2*size_of_bodies, height-2*size_of_bodies)));
  }
}

void keyPressed() {
  if (key == ' ') {
    debug =! debug;
  }
  if (key == 'f') {
    fastMode =! fastMode;
    fastmode(fastMode);
  }
}

void fastmode(boolean t) {
  if (t) frameRate(1000);
  else frameRate(60);
}
