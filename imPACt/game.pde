public class game {
  int[][] maze;
  
  public game() {
    maze = null;
  }
  
  void drawBackground() {
    rectMode(CENTER);
    
    fill(255);
    square(0, 0, 1600);
  }
}
