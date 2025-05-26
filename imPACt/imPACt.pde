//text font
PFont font;
PImage start;

//screens 
String currentScreen = "start"; //

start startScreen;

void setup() {
  size(800, 800);
  startScreen = new start();
 
}

void draw() {
  switch(currentScreen) {
    case "start":
      startScreen.drawStart();
      break;
    case "game":
      background(0);
      break;
    case "avatar":
      background(255);
      break;
  }
  
  
}

void mousePressed() {
  //from start to game
  if (startScreen.overButton(400, 400, 500, 200)) {currentScreen = "game";}
  if (startScreen.overButton(400, 630, 550, 150)) {currentScreen = "avatar";}
 
}
