import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
BeatDetect beat;
String filename;
void setup()
{
  size(displayWidth, displayHeight);
  minim = new Minim(this);
  selectInput("select a music file to visualize:", "fileSelected");
  interrupt();
  player = minim.loadFile(filename, 2048);
  beat = new BeatDetect();
  player.play();
  noCursor();
  
  ellipseMode(RADIUS);
}

void fileSelected(File selection) {
  if(selection == null) {
    println("Window was closed or the user hit cancel."); 
  } else {
    println("success");
    filename = selection.getAbsolutePath();
  }
}

void interrupt() {
  while(filename == null) {
    noLoop(); 
  }
  loop();
}

void draw()
{ 
  background(0);
  beat.detect(player.mix);
  //set new origin to be the center of the screen
  translate(width/2, height/2);
  stroke(52, 73, 94);
  noFill();
  strokeWeight(2);
  int bSize = player.bufferSize();
  boolean superPulse = false;
  for(int i = 0; i < bSize - 1; i+=5) {
    float x2 = player.left.get(i)*100;
    float y2 = player.left.get(i)*100;
    if(abs(x2) > 50) {
      //make ellipse red, lines white
      stroke(231, 76, 60); 
      superPulse = true;
    }
    ellipse(0, 0, x2, y2);
  }
   
  if(superPulse) {
    //white
    stroke(255, 255, 255);
  } else {
    //default blue
    stroke(52, 152, 219);
  }
    
  beginShape();
  noFill();
  strokeWeight(3);
  for (int i = 0; i < bSize; i+=7)
  {
    float x = (200 + player.left.get(i) * 100) * cos(i*2*PI/bSize);
    float y = (200 + player.left.get(i) * 100) * sin(i*2*PI/bSize);
    vertex(x, y);
    pushStyle();
    stroke(-1);
    popStyle();
  }
  endShape();
}