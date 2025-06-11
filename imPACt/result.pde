public class result {
  private PFont fontSuperBig;
  private PFont fontBig;
  private PImage heartImg;
  private PImage starImg;
  
  private color currentButtonColor;
  private color buttonColor;
  private color highlightColor;
  
  private boolean isWin;
  private game myGame; 
  
  public result(boolean win, game game) {
    fontSuperBig = loadFont("TimesNewRomanPS-BoldMT-140.vlw");
    fontBig = loadFont("TimesNewRomanPS-BoldMT-40.vlw");
    heartImg = loadImage("heart.png");
    starImg = loadImage("star.png");
    
    isWin = win;
    myGame = game;
    currentButtonColor = color(0);
    buttonColor = color(0);
    highlightColor = color(0);
  }
  
  void drawResult() {
    if (isWin)
    {
      rectMode(CENTER);  
      
      noStroke();
      fill(#b6ffba);
      square(0, 0, 1600);
      
      stroke(255);
      strokeWeight(4);
      fill(#f0ffeb);
      rect(400, 400, 750, 750, 40);
   
      fill(#7e9c7e);
      textAlign(CENTER, CENTER);
      textFont(fontSuperBig);
      text("You Win!", 400, 200);
      fill(#cdfcd0);
      textFont(fontBig);
      text("Awesome Job. You did amazing!", 400, 280);
      fill(#b6ffba);
      for (int i = 0; i < 5; i++)
      {
        image(starImg, 168 + (i * 100), 320, 50, 50);
      }
      fill(#7e9c7e);
      textFont(fontBig);
      text("Your Score: " + myGame.getScore(), 200, 400);
      text("Your Time: " + myGame.getTime(), 550, 400);
      
      buttonColor = #b6ffba;
      highlightColor = #f0ffeb;
      
      if (overButton(400, 500, 550, 100))
      {
        currentButtonColor = highlightColor;
      }
      else 
      {
        currentButtonColor = buttonColor;
      }
      
      stroke(255);
      strokeWeight(5);
      fill(currentButtonColor);
      rectMode(CENTER);
      rect(400, 500, 550, 100, 28);
      
      //text
      fill(#7e9c7e);
      textAlign(CENTER, CENTER);
      text("try again", 400, 500);
    }
    else
    {
      rectMode(CENTER);
      
      noStroke();
      fill(#ffc0cb);
      square(0, 0, 1600);
      
      stroke(255);
      strokeWeight(4);
      fill(#ffedeb);
      rect(400, 400, 750, 750, 40);
   
      fill(#9c7e7e);
      textAlign(CENTER, CENTER);
      textFont(fontSuperBig);
      text("Game Over", 400, 200);
      fill(#fccde1);
      textFont(fontBig);
      text("You can do this! Try again!", 400, 280);
      for (int i = 0; i < 5; i++)
      {
        image(heartImg, 168 + (i * 100), 320, 50, 50);
      }
      fill(#9c7e7e);
      textFont(fontBig);
      text("Your Score: " + myGame.getScore(), 200, 400);
      text("Your Time: " + myGame.getTime(), 550, 400);
      
      buttonColor = #ffc0cb;
      highlightColor = #fccde1;
      
      if (overButton(400, 500, 550, 100))
      {
        currentButtonColor = highlightColor;
      }
      else 
      {
        currentButtonColor = buttonColor;
      }
      
      stroke(255);
      strokeWeight(5);
      fill(currentButtonColor);
      rectMode(CENTER);
      rect(400, 500, 550, 100, 28);
      
      //text
      fill(#9c7e7e);
      textAlign(CENTER, CENTER);
      text("try again", 400, 500);
    }
  }
  
  boolean overButton(int x, int y, int w, int h) {
    return mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2;
  }
 
}
