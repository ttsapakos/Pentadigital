public class Hand
{
  int xPos;
  int yPos;
  int velo;
  boolean isDead;
  
  Hand(int xPos) {
    this.xPos = xPos;
    this.yPos = height + 25;
    this.velo = (int)random(10);
    this.isDead = false;
  }

  void update() {
    this.velo -= 1;
    this.yPos -= velo;
    if(this.yPos > height + 100) 
      this.isDead = true;
  }
  
  void display() {
    stroke(0);
    fill(0);
    pushMatrix();
    translate(xPos, yPos);
    ellipse(-25, -25, 50, 50);
    popMatrix();
  } 
}
