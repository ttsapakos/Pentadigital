ArrayList<Hat> hList = new ArrayList<Hat>(); //creates hat list

public int width = 640; 
public int height = 360;
boolean run;

void setup() {
  size(width, height); //creates screen
}

void draw() {
  background(color(140,220,255)); //sky blue
  for(int i = 0; i < hList.size(); i++) { //displays all hats in list
    hList.get(i).display();
    hList.get(i).update();
  }
  autohat();
  kill();
  println(hList.size()); //debugger
}

void kill(){ //kills nonvisible hats and hands
  for(int i = 0; i < hList.size(); i++) {
    boolean isDead = hList.get(i).isDead; //calls isDead
    if(isDead){
       hList.remove(i); 
    }
  }
}

void autohat(){ //auto hat-thrower
  if(run == true){
    if(hList.size() < 20){ //throws N hats sequentially (63 maximum, self-loops at 64)
       hList.add(new Hat());
    }
    else{
      run = false; //stops after N hats
    }
  }
}

void mousePressed() { //mouse input handler
  if(mouseButton == LEFT){
    hList.add(new Hat()); //adds hat to list
  }
  else if(mouseButton == RIGHT){ //toggles autohat
    if(run == true){
       run = false;
    }
    else{
      run = true;
    } 
  }
}
 
