/*public class Hand
{
  int xPos;
  int yPos;
  float velo;
  boolean isDead;
  
  Hand(int xPos) {
    this.xPos = xPos;
    this.yPos = height + 40; //starts hand below screen
    this.velo = floor(random(2)) * ((int)random(5) + 5); //hand occasionally is fast enough to appear
    this.isDead = false;
  }

  void update() {
    this.velo -= 1; //slows hand
    this.yPos -= velo; //moves hand 
    if(this.yPos > height + 300) //marks hand for death
      this.isDead = true; 
  }
  
  void display() {
    stroke(0);
    fill(color(255,224,189)); //flesh tone
    pushMatrix(); 
    translate(xPos, yPos);
    ellipse(-25, -25, 40, 40); //placeholder for graphics
    popMatrix();
  } 
  
}
*/
