public class start {
 PFont font;
 PImage background;
 
 color currentButtonColor;
 color buttonColor;
 color highlightColor;
 
 public start() {
   font = loadFont("TimesNewRomanPS-BoldMT-40.vlw");
   background = loadImage("data/start.jpg");
   currentButtonColor = #ffc0cb;
   buttonColor = #ffc0cb;
   highlightColor = #fce5ef;
 }
 
  void drawStart() {   
    image(background, 0, 0);
    drawStartButton();

  }
  
  void drawStartButton() {
    if (overButton(400, 400, 550, 100))
    {
      currentButtonColor = highlightColor;
    }
    else 
    {
      currentButtonColor = buttonColor;
    }
    
    //button
    stroke(#fffcd3);
    strokeWeight(5);
    fill(currentButtonColor);
    rectMode(CENTER);
    rect(400, 400, 550, 100, 28);
    
    //text
    textAlign(CENTER, CENTER);
    fill(255);
    textFont(font);
    text("start game", 400, 400);
  }

  boolean overButton(int x, int y, int w, int h) {
    return mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2;
  }
 
}
