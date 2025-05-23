//text font
PFont font = createFont("GentiumBasic-Bold-48.vlw", 50);

//start screen
String currentScreen = "start";
color currentColor = #FFADDD;
color buttonColor = #FFADDD;
color buttonHighlight = #FFE0F2;

void setup() {
  size(720, 720);
  background(#FFCEEB);
  
  
  switch(currentScreen) {
    case "start":
      stroke(225);
      fill(buttonColor);
      rectMode(CENTER);
      rect(360, 400, 280, 100, 28);
      
      textMode(CENTER);
      textFont(font);
      text("start", 360, 400);
  }
}

void draw() {
  update(mouseX, mouseY);
  background(#FFCEEB);
  
  switch(currentScreen) {
    case "start":
      stroke(255);
      fill(currentColor);
      rectMode(CENTER);
      rect(360, 400, 280, 100, 28);
  }
}

void update(int x, int y) {
  switch(currentScreen) {
    case "start":
      if (overRectButton(360, 400, 280, 100))
      {
        currentColor = buttonHighlight;
      }
      else
      {
         currentColor = buttonColor;
      }
  }
}

boolean overRectButton(int x, int y, int w, int h) {
  return mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2;
}
