public class ghost {
  color ghostColor;
  
  public ghost() {
    ghostColor = color(random(255), random(255), random(255));
  }
  
  void drawGhost(int x, int y, int size) {
     //body
     noStroke();
     fill(ghostColor);
     square(x, y, size);
     fill(255);
     
     triangle(x - size * 0.5, y + size * 0.5, x - size * 0.25, y - 10, x, y + size * 0.5);
  }
}
