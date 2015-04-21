// include ArrayList

// perform vector math on xyz movement, only draw in the xy. Position declared as a vector, but drawn as xy coordinates

// calculate xy as normal xy plane where 0 is the ground, then transform y at draw level to account for processings interpreteation of line scanning
// (y' = -1*(y-SCREEN_HEIGHT+1))

PShape hat;
PShape hand;

PVector GRAVITY = new PVector(0,-0.01,0); // Acceleration due to Gravity
float AIR_SCALAR = (-0.025); // Acceleration due to Air

int SCREEN_WIDTH = 500;
int SCREEN_HEIGHT = 800;

int ROCKET_SPAWN_SPACE = 25;

int ROCKET_TTL = 100;
int SPARK_TTL = 75;
int FLASH_TTL = 100;
int HAT_TTL = 100;
int HAND_TTL = 100;
int SPARK_BURST_SPEED = 2;

int ROCKET_SIZE = 3;
int SPARK_SIZE = 2;
int EXPLOSION_SIZE = 300;

int MAX_FLASH_SIZE = max(SCREEN_HEIGHT, SCREEN_WIDTH);
int FLASH_DIFFUSION = 25;
int FLASH_GROWTH = 25;
color BGCOL = #333333;

color RocketColor = #DDDDDD;

color[] palette = {#B1EB00, #53BBF4, #FF85CB, #FF432E, #FFAC00, #982395, #0087CB, #ED1C24, #9C0F5F, #02D0AC};

color randomVibrant() {
  /*
  float rgb[] = {random(150, 255), random(150, 255), random(150, 255)};
  for (int i = 0; i < rgb.length; i++) {
      if(rgb[i] < 175) {
          rgb[i] = 0;
      }
  }
  return color(rgb[0], rgb[1], rgb[2]);
  */
  return palette[int(random(0,palette.length))];
  
}

int drawY(int y) {
  return -1 * (1 + y - SCREEN_HEIGHT);
}

protected class Spawner<T> {
  // Fields
  protected PVector PMax; // Max Position
  protected PVector PMin; // Min Position
  protected PVector VMax; // Max Velocity
  protected PVector VMin; // Min Velocity
  protected PVector AMax; // Max Acceleration
  protected PVector AMin; // Min Acceleration
  
  protected ArrayList<T> children;  // children spawned by Spawner
  
  protected int tts;  // Time 'til spawn
  
  public Spawner() {
    PMin = new PVector(0, 0, 0);
    VMin = new PVector(-50, -50, -50);
    AMin = new PVector(-10, -10, -10);
      
    PMax = new PVector(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_HEIGHT);
    VMax = new PVector(50, 50, 50);
    AMax = new PVector(10, 10, 10);
    
    children = new ArrayList<T>();
  }
  
  public void spawn(T child) {
    children.add(child);
  } //end SPawner::spawn()
  
}

protected class RocketSpawner extends Spawner<Rocket> {
  
  public RocketSpawner() {
    PMin = new PVector(0, 1, 0);
    VMin = new PVector(-50, -50, -50);
    AMin = new PVector(-10, -10, -10);
      
    PMax = new PVector(SCREEN_WIDTH, 1, SCREEN_WIDTH);
    VMax = new PVector(50, 50, 0);
    AMax = new PVector(10, 10, 0);
    
    children = new ArrayList<Rocket>();
    
    tts = 0;
  }
  // Methods
  public void update() {
    // if time to spawn new one, spawn new 
    tts--;
    if (tts <= 0) {
      tts = ROCKET_SPAWN_SPACE;
      PVector p = new PVector(250, 100, 0);
      PVector vr = PVector.random2D();
      vr.setMag(2);
      PVector v = new PVector(0, 15, 0);
      v.add(vr);
      PVector a = new PVector(0, 0, 0);
      Rocket newRocket = new Rocket(p, v, a);
      spawn(newRocket);
    }
    // for each rocket in rockets r.update();
    ArrayList<Rocket> garbage = new ArrayList<Rocket>();
    for (Rocket r : children) {
      if (!r.update()) { //update
        garbage.add(r);
      }
    }
    for (Rocket g : garbage) {
        children.remove(g);
    }
  } // end RocketSpawner::update()
  
  
  public void  draw() {
    for (Rocket r : children) {
      r.draw();
    }
  } // end RocketSpawner::draw()
  
  
}

/*
Hats at a constant rate
Slightly different sizes of hats and hands
Hands about every 10 hats
Correct hat and hand graphic
*/

protected class HatSpawner extends Spawner<Hat> {
  
  HatSpawner() {
    PMin = new PVector(0, 1, 0);
    VMin = new PVector(-50, -50, -50);
    AMin = new PVector(-10, -10, -10);
      
    PMax = new PVector(SCREEN_WIDTH, 1, SCREEN_WIDTH);
    VMax = new PVector(50, 50, 0);
    AMax = new PVector(10, 10, 0);
    
    children = new ArrayList<Hat>();
    
    tts = 0;
  }
  
  public void spawn() {
    PVector childPos = PMin;
    PMin.x += random(SCREEN_WIDTH);
    PVector childVel = VMin;
    children.add(new Hat());
  }
  
  public void update() {
    
    /*
    while (children.size() < 10) {
      this.spawn();
    }
    */
    
    // This section makes it so that the hats keep spawning
    tts--;
    while(tts < 0){
      this.spawn();
      tts = 10;
    }
    
    ArrayList<Hat> garbage = new ArrayList<Hat>();
    for(Hat h : children) {
      h.update();
      if (h.ttl < 0) {
        garbage.add(h);
      }
    }
    for (Hat h : garbage) {
      children.remove(h);
    }
  }
  
  public void draw() {
    for(Hat h : children) {
      h.draw();
    }
  }
  
}

protected class HandSpawner extends Spawner<Hand> {
  
  HandSpawner() {
    PMin = new PVector(0, 1, 0);
    VMin = new PVector(-50, -50, -50);
    AMin = new PVector(-10, -10, -10);
      
    PMax = new PVector(SCREEN_WIDTH, 1, SCREEN_WIDTH);
    VMax = new PVector(50, 50, 0);
    AMax = new PVector(10, 10, 0);
    
    children = new ArrayList<Hand>();
    
    tts = 0;
  }
  
  public void spawn() {
    PVector childPos = PMin;
    PMin.x += random(SCREEN_WIDTH);
    PVector childVel = VMin;
    children.add(new Hand());
    println(children.size());
  }
  
  public void update() {
    
    // This section makes it so children spawn in bursts
    while (children.size() < 5) {
      this.spawn();
      
    }
    
    // This section makes it so that the hats keep spawning
    /*
    tts--;
    while(tts < 0){
      this.spawn();
      tts = 10;
    }
    */
    
    ArrayList<Hand> garbage = new ArrayList<Hand>();
    for(Hand h : children) {
      h.update();
      if (h.ttl < 0) {
        garbage.add(h);
      }
    }
    for (Hand h : garbage) {
      children.remove(h);
    }
  }
  
  public void draw() {
    for(Hand h : children) {
      h.draw();
    }
  }
}

protected class SparkSpawner extends Spawner<Spark> {
  protected PVector position;
  protected PVector velocity;
  protected color sparkColor1, sparkColor2;
  
  
  // Methods
  SparkSpawner(PVector p, PVector v) {
    // creates sparks and adds to arraylist of sparks
    position = new PVector(0,0,0);
    position.set(p);
    
    velocity = new PVector(0,0,0);
    velocity.set(v);
    sparkColor1 = randomVibrant();
    sparkColor2 = randomVibrant();
    
    children = new ArrayList<Spark>();
    
    explode();
  } // end SparkSpawner()
  
  SparkSpawner(PVector p) {
    // creates sparks and adds to arraylist of sparks
    position = new PVector(0,0,0);
    position.set(p);
    sparkColor1 = randomVibrant();
    sparkColor2 = randomVibrant();
    
    velocity = null;
    
    children = new ArrayList<Spark>();
    
    explode();
  } // end SparkSpawner()
  
  public void explode() {
    for (int i = 0; i < EXPLOSION_SIZE; i++) {
      
      PVector initV = PVector.random3D(); // randomize initial velocity 
      initV.setMag(SPARK_BURST_SPEED);    // normalize to desired burst speed
      
      if (velocity != null) {
        initV.add(velocity); // add spawners velocity if it exists
      }
      PVector a = new PVector(0, 0, 0);
      Spark newSpark = new Spark(position, initV, a, sparkColor1, sparkColor2);
      spawn(newSpark);
    }
  } // end explode()
  
  public boolean update() {
    ArrayList<Spark> garbage = new ArrayList<Spark>();
    for (Spark s : children) {
      if (!s.update()) { //update
        garbage.add(s);
      }
    }
    for (Spark g : garbage) {
        children.remove(g);
    }
    return children.size() > 0;
  } // end SparkSpawner::update()
  
  public void draw() {
    for (Spark s : children) {
      s.draw();
    }
  } // end SparkSpawner::draw()
}

protected class Particle {

  protected PVector position;
  protected PVector velocity;
  protected PVector acceleration;
  protected int ttl; // time to live
  
  /*
  protected float transparency;
  protected float size;
  color Color;
  */
  
  Particle() {
    position = new PVector(random(0,SCREEN_WIDTH), random(0,SCREEN_HEIGHT), 0);
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
   
    ttl = ROCKET_TTL;
  } // end Rocket()  
  
  Particle(PVector p, PVector v, PVector a) {
    position.set(p);
    velocity.set(v);
    acceleration.set(a);
    ttl = ROCKET_TTL;
  } // end Rocket()
  
  public void move() {
    // A' = A_g + V*R_air + A
    PVector tempAcceleration = PVector.mult(velocity, AIR_SCALAR);
    tempAcceleration.add(GRAVITY);
    tempAcceleration.add(acceleration); // base acceleration + environment
    velocity.add(tempAcceleration);
    position.add(velocity);
  } // end Particle::move()
  

}

protected class Rocket extends Particle {
  protected SparkSpawner SS;
  
    
  Rocket() {
    position = new PVector(random(0,SCREEN_WIDTH), random(0,SCREEN_HEIGHT), 0);
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    
    SS = null;
   
    ttl = ROCKET_TTL;
  } // end Rocket()  
  
  Rocket(PVector p, PVector v, PVector a) {
    
    position = new PVector(0, 0, 0);
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    
    position.set(p);
    velocity.set(v);
    acceleration.set(a);
    
    SS = null;
    
    ttl = ROCKET_TTL;
  } // end Rocket()
  
  public boolean update() {
    ttl--;
    if (velocity.y <= 0) {
      if (SS == null) {
        SS = new SparkSpawner(position, velocity);
      }
      return SS.update();
    }
    else {
      this.move();
      return true;
    }
  } // end Rocker::update()
  
  public void draw() {

    if (ttl >= 0) {

      noStroke();
      fill(RocketColor);
      
      ellipse(int(position.x), drawY(int(position.y)), ROCKET_SIZE, ROCKET_SIZE);
    }

    if (SS != null) {
      SS.draw();
    }
  } // end Rocker::draw()
  
}

protected class Spark extends Particle {
  color from;
  color to;
  color[] lerpVector; // gradient for sparks
  
  
  Spark(PVector p, PVector v, PVector a, color color1, color color2) {
    position.set(p);
    velocity.set(v);
    acceleration.set(a);
    ttl = SPARK_TTL + int(random(0,30));
    from = color1;
    to = color2;
    
    lerpVector = new color[ttl];
    float stepSize = 1.0 / float(ttl);
    for(int i = 0; i < ttl; i++) {
      lerpVector[i] = lerpColor(from, to, stepSize * i);
    }
  } // end Spark::Spark()
  
  public boolean update() {
    ttl--;
    if (ttl > 0) {
      move();
      return true;
    }
    return false;
  }
  public void draw() {
    // Draw the spark at p
    if (ttl > 0) {
      noStroke();
      fill(lerpVector[ttl]);
      //fill(from);
      ellipse(int(position.x), drawY(int(position.y)), SPARK_SIZE, SPARK_SIZE);
    }
  }
}


protected class FlashSpawner extends Spawner<Flash>{
  double TimeToFlash;
  
  public FlashSpawner(){
    TimeToFlash = Math.random() * 30 + 50;
    this.children = new ArrayList<Flash>();
  }  
  
  void update(){
    TimeToFlash--;
    if(TimeToFlash < 0){
      TimeToFlash = Math.random() * 30 + 50;
      spawn(new Flash());
      
    }
    
    ArrayList<Flash> garbage = new ArrayList<Flash>();
    for(Flash f : children){
       if(!f.update()) {
          garbage.add(f);     
       } 
    }
    
    for (Flash g : garbage) {
        children.remove(g);
    }
    
  }
  void draw(){
    for(Flash f : children){
      f.draw(); 
    }
  }
  
}

class Flash extends Particle{
  int size;
  int alpha;
 
  Flash() {
    position = new PVector(random(0,SCREEN_WIDTH), random(0,SCREEN_HEIGHT), 0);
    size = 0;
    alpha = 255;
  } // end Flash()
  
  public boolean update(){

      size += FLASH_GROWTH;
      alpha -= FLASH_DIFFUSION;

      if(size >= MAX_FLASH_SIZE){
         return false;
      }
      return true;
  }
  
  public void draw(){
    //blendMode(ADD);
    fill(250, alpha);
    ellipse(position.x, drawY(int(position.y)), size, size);
  }
}

class Hat extends Particle {

  float rot;
  float spin;
  int size; // 4, 5, 6... kinda bad numbers but it works
  //Hand hand;

  Hat() {
    position = new PVector(random(0,SCREEN_WIDTH), SCREEN_HEIGHT, 0);
    velocity = new PVector(random(-5f, 5f),random(-50, -40) ,0);
    acceleration = new PVector(0,0,0);
    this.spin = random(-.2f, .2f);
    ttl = HAT_TTL;
    size = (int)random(3)+4;
    //this.hand = new Hand(position, velocity, acceleration);
  } // end Hat()  
  
  Hat(PVector p, PVector v, PVector a, float spin) {
    position.set(p);
    velocity.set(v);
    acceleration.set(a);
    this.spin = spin;
    ttl = HAT_TTL;
    //hand = new Hand(p, v, a);
  } // end Hat()
  
  public void update() {
    ttl--;
    // A' = A_g + V*R_air + A
    PVector tempAcceleration = PVector.mult(velocity, AIR_SCALAR);
    rot += spin;
    PVector thisGrav = new PVector(0., 1., 0.); // FIXME
    tempAcceleration.add(thisGrav);
    tempAcceleration.add(acceleration); // base acceleration + environment
    velocity.add(tempAcceleration);
    position.add(velocity);
    //hand.update();
  } // end Hat::move()
  
  void draw() {
    
    stroke(0);
    fill(0);
    pushMatrix(); //allows rotation of hat around itself
    translate(position.x, position.y);
    rotate(rot % 360); 

    // actual graphics
    shape(hat, -10 * size, -10 * size, 20 * size, 20 * size);

    //placeholder for graphics
    //rect(-25, -25, 50, 50);
    
    popMatrix();
    //this.hand.draw(); //calls hand draw
  } 
  
}

class Hand extends Particle {

  int size;
  
  Hand() {
    position = new PVector(random(0,SCREEN_WIDTH), random(SCREEN_HEIGHT+50, SCREEN_HEIGHT+100), 0);
    velocity = new PVector(0,-20,0);
    acceleration = new PVector(0,0,0);
   
    ttl = HAND_TTL;
    
    size = (int)random(3)+4;
    
  } // end Hand()  
  
  /*
  Hand(PVector p, PVector v, PVector a) {
    position.set(p);
    velocity.set(v);
    acceleration.set(a);
    ttl = HAND_TTL;
  } // end Hand()
  */
  
  public void update() {
    // A' = A_g + V*R_air + A
    PVector tempAcceleration = PVector.mult(velocity, AIR_SCALAR);
    //tempAcceleration.add(GRAVITY);
    
    PVector thisGrav = new PVector(0., 1., 0.); // FIXME
    tempAcceleration.add(thisGrav);
    
    tempAcceleration.add(acceleration); // base acceleration + environment
    velocity.add(tempAcceleration);
    position.add(velocity);
    ttl--;
  } // end Hand::move()
  
  void draw() {
    //println("okay! position: " + position.x + " " + position.y);
    stroke(0);
    //fill(color(255,224,189)); //flesh tone
    pushMatrix(); 
    translate(position.x, position.y);
    shape(hand, -10 * size, -10 * size, 20 * size, 20 * size);
    //ellipse(-25, -25, 40, 40); //placeholder for graphics
    popMatrix();
  } 
  
}

RocketSpawner RS;
FlashSpawner FS;
HatSpawner HS;
HandSpawner HANDS;

void setup() {
  size(SCREEN_WIDTH,SCREEN_HEIGHT);
  smooth();
  //RS = new RocketSpawner();
  //FS = new FlashSpawner();
  HS = new HatSpawner();
  HANDS = new HandSpawner();
  hand = loadShape("hand-toss.svg");
  hat = loadShape("hat.svg");
  //frameRate(20);
}

void draw() {
  background(BGCOL);
  //RS.update();
  //RS.draw();
  //FS.update();
  //FS.draw();
  
  HS.update();
  HS.draw();
  HANDS.update();
  HANDS.draw();
  
  
  // Making sure the hand can be drawn
  //shape(hand, 100, 100, 100, 100);
  
}
