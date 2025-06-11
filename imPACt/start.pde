public class start {
 private PFont fontBig;
 private PFont fontSmall;
 private PImage background;
 
 private color currentButtonColor;
 private color buttonColor;
 private color highlightColor;
 
 public start() {
   fontBig = loadFont("TimesNewRomanPS-BoldMT-40.vlw");
   fontSmall = loadFont("TimesNewRomanPS-BoldMT-25.vlw");
   background = loadImage("data/start.jpg");
   currentButtonColor = #ffc0cb;
   buttonColor = #ffc0cb;
   highlightColor = #fce5ef;
 }
 
  void drawStart() {   
    image(background, 0, 0);
    
    rectMode(CENTER);
    stroke(#e1f5fc);
    strokeWeight(5);
    fill(#fffcd3);
    rect(525, 620, 350, 225, 28);
    drawStartButton();
    
    fill(#ffc0cb);
    textAlign(CENTER, CENTER);
    textFont(fontBig);
    text("instructions", 525, 530);
    fill(#9c7e7e);
    textAlign(LEFT, LEFT);
    textFont(fontSmall);
    text("- press 'h' and arrow keys to\nswitch hair color", 362, 575);
    text("- press 's' and arrow keys to\nswitch skin color", 362, 630);
    text("- press '1', '2', and '3' to\nswitch difficulty", 362, 685);
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
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(fontBig);
    text("start game", 400, 400);
  }

  boolean overButton(int x, int y, int w, int h) {
    return mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2;
  }
 
}
