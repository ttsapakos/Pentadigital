public class Hat
{
  int xPos;
  int yPos;
  int velo;
  boolean isDead;
  Hand hand;
  float rot;
  float spin;
  
  Hat() {
    this.xPos = (int)random(width);
    this.yPos = height;
    this.velo = (int)random(10) + 20;
    this.isDead = false;
    this.hand = new Hand(this.xPos);
    this.rot = random(360);
    this.spin = random(-0.3, 0.3);
  }

  void update() {
    this.velo -= 1;
    this.yPos -= velo;
    if(this.yPos > height + 100) 
      this.isDead = true;
    this.rot += this.spin;
    this.hand.update();
  }
  
  void display() {
    stroke(0);
    fill(0);
    pushMatrix();
    translate(xPos, yPos);
    rotate(rot % 360);
    rect(-25, -25, 50, 50);
    popMatrix();
    this.hand.display();
  } 
}
