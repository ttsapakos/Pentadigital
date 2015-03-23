public class Hat
{
  int xPos;
  int yPos;
  int velo;
  boolean isDead;
  
  Hat() {
    this.xPos = (int)random(width);
    this.yPos = height;
    this.velo = (int)random(20) + 10;
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
    rect(xPos, yPos, 50, 50);
  } 
}
