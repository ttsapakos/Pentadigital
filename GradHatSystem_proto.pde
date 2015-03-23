ArrayList<Hat> hList = new ArrayList<Hat>();

public int width = 640;
public int height = 360;

void setup() {
  size(width, height);
}

void draw() {
  background(255);
  for(int i = 0; i < hList.size(); i++) {
    hList.get(i).display();
    hList.get(i).update();
  }
}
 
void mousePressed() {
  hList.add(new Hat());
}
 
