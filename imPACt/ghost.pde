public class ghost {
  color ghostColor;
  
  public ghost() {
    ghostColor = color(random(255), random(255), random(255));
  }
  
  void drawGhost(int x, int y, int size) {
    rectMode(CENTER); 
    
    //body
    noStroke();
    fill(ghostColor);
    square(x, y, size);
     
    //body cutouts 
    fill(0); //should be what color the background is
    float tWidth = size / 3.0;
    float tHeight = size / 5.5;
    for (int i = 0; i < 3; i++)
    {
      float tX = x - (size / 2) + (i * tWidth);
      float tY = y + (size / 2) + 1;
      triangle(tX, tY, tX + (tWidth / 2), tY - tHeight, tX + tWidth, tY);
    }
    
    //eyes
    fill(0);
    square(x - (size * 0.2), y + (size * 0.1), size * 0.2);
    square(x + (size * 0.2), y + (size * 0.1), size * 0.2);
    fill(255);
    square(x - (size * 0.26), y + (size * 0.04), size * 0.08);
    square(x + (size * 0.14), y + (size * 0.04), size * 0.08);
     
    //blush
    fill(#ffc0cb);
    ellipse(x - (size * 0.3), y + (size * 0.25), size * 0.2, size * 0.15);
    ellipse(x + (size * 0.3), y + (size * 0.25), size * 0.2, size * 0.15);
  }
}
