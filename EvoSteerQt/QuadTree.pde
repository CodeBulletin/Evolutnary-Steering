class QuadTree {
  Rectangle boundary;
  int capacity;
  ArrayList<Point> points;
  QuadTree northeast, northwest, southwest, southeast;
  boolean sub_divided = false;
  QuadTree(Rectangle _boundary, int n) {
    boundary = _boundary;
    capacity = n;
    points = new ArrayList<Point>();
  }
  void clear(){
    points = new ArrayList<Point>();
    sub_divided = false;
    northeast = northwest = southwest = southeast = null;
  }
  void subdivide() {
    Rectangle NE = new Rectangle(boundary.x + boundary.w/2, boundary.y - boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle NW = new Rectangle(boundary.x - boundary.w/2, boundary.y - boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle SW = new Rectangle(boundary.x - boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2);
    Rectangle SE = new Rectangle(boundary.x + boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2);
    northeast = new QuadTree(NE, capacity);
    northwest = new QuadTree(NW, capacity);
    southwest = new QuadTree(SW, capacity);
    southeast = new QuadTree(SE, capacity);
    sub_divided = true;
  }
  void insert(Point P) {
    if (!boundary.contains(P)) {
      return;
    }
    if (points.size() < capacity) {
      points.add(P);
    } else {
      if (!sub_divided) {
        subdivide();
      }
      northeast.insert(P);
      northwest.insert(P);
      southwest.insert(P);
      southeast.insert(P);
    }
  }
  void show() {
    rect(boundary.x, boundary.y, boundary.w*2, boundary.h*2);
    if (sub_divided) {
      northeast.show();
      northwest.show();
      southwest.show();
      southeast.show();
    }
  }
  ArrayList<Point> query(Circle range, ArrayList<Point> found){
    if(found == null){
      found = new ArrayList<Point>();
    }
    if(!boundary.intersect(range)){
      return null;
    } else {
      for(Point P : points){
        if(range.contains(P)){
          found.add(P);
        }
      }
      if(sub_divided){
        northeast.query(range, found);
        northwest.query(range, found);
        southwest.query(range, found);
        southeast.query(range, found);
      }
    }
    return found;
  }
}

class Point{
  float x, y;
  PVector P1 = null, P2 = null;
  Prey P3 = null;
  Predators P4 = null;
  Point(float _x, float _y, PVector P, boolean isFood){
    x = _x;
    y = _y;
    if(isFood){
      P1 = P;
    } else {
      P2 = P;
    }
  }
  Point(float _x, float _y, Prey P){
    x = _x;
    y = _y;
    P3 = P;
  }
  Point(float _x, float _y, Predators P){
    x = _x;
    y = _y;
    P4 = P;
  }
}

class Rectangle{
  float x, y, w, h;
  Rectangle(float _x, float _y, float _w, float _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  boolean contains(Point P){
    return P.x <= x + w && P.x >= x - w && P.y <= y + h && P.y >= y - h;
  }
  boolean intersect(Circle C){
    return x-C.x <= w + C.d/2 && y-C.y <= h + C.d/2; 
  }
}

class Circle{
  float x, y, d;
  Circle(float _x, float _y, float _d){
    x = _x;
    y = _y;
    d = _d;
  }
  boolean contains(Point P){
    return dist(x, y, P.x, P.y) < d/2;
  }
}
