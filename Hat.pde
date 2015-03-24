public class Hat
{
  int xPos;
  int yPos;
  int xVelo;
  int yVelo;
  boolean isDead;
  Hand hand;
  float rot;
  float spin;
  
  Hat() {
    this.xPos = (int)random(width); //starts hat at random X position onscreen
    this.yPos = height; //starts hat at bottom of screen
    this.xVelo = (int)random(-3, 3);
    this.yVelo = (int)random(10) + 20; //throws hat
    this.isDead = false;
    this.hand = new Hand(this.xPos + (int)random(50)); //generates hand nearby
    this.rot = random(-90, 90); //starts hat tilted
    this.spin = random(-0.1, 0.1); //gives hat angular velocity
  }

  void update() {
    this.yVelo -= 1; //slows hat
    this.xPos += xVelo;
    this.yPos -= yVelo; //moves hat
    if(this.yPos > height + 300)
      this.isDead = true; 
    this.rot += this.spin; //rotates hat
    this.hand.update(); //calls hand update
  }
  
  void display() {
    stroke(0);
    fill(0);
    pushMatrix(); //allows rotation of hat around itself
    translate(xPos, yPos);
    rotate(rot % 360); 
    rect(-25, -25, 50, 50); //placeholder for graphics
    popMatrix();
    this.hand.display(); //calls hand display
  } 
  
}
