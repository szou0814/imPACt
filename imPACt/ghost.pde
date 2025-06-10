public class ghost {
  PVector pos;
  PVector spd;
  PVector targetTile = new PVector(0, 0);
  PVector prevDir = new PVector(0, 0);
  color ghostColor;
  
  public ghost(int x, int y) {
    pos = new PVector(x * 40, y * 40);
    targetTile = pos.copy();
    ghostColor = color(random(255), random(255), random(255));
  }
  
  void drawGhost(int x, int y, int size) {
    rectMode(CENTER); 
    
    //body
    noStroke();
    fill(ghostColor);
    square(x, y, size);
     
    //body cutouts 
    fill(#fffcd3); //should be what color the background is
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
  
  void move(int[][] maze) {
    ArrayList<PVector> directions = new ArrayList<PVector>();
    PVector[] dirs = {new PVector(-1, 0), new PVector(1, 0), new PVector(0, -1), new PVector(0, 1)};

    for (PVector d : dirs) 
    {
      int newX = posX + (int)d.x;
      int newY = posY + (int)d.y;
      
      //WALL = 1, GHOST = 3
      if (newX >= 0 && newX < maze.length && newY >= 0 && newY < maze[0].length && maze[newX][newY] != 0 && maze[newX][newY] != 3) 
      {
        if (!(d.x == -prevDir.x && d.y == -prevDir.y))
        {
          directions.add(d);
        }
      }
    }
    
    if (directions.size() == 0)
    {
      for (PVector d : dirs) 
      {
        int newX = posX + (int)d.x;
        int newY = posY + (int)d.y;
        
        if (newX >= 0 && newX < maze.length && newY >= 0 && newY < maze[0].length && maze[newX][newY] != 0 && maze[newX][newY] != 3) 
        {
          directions.add(d);
        }
      }
    }
    
    if (directions.size() > 0)
    {
      PVector choice = directions.get((int)random(directions.size()));
      
      maze[posX][posY] = 1;
      posX += (int)choice.x;
      posY += (int)choice.y;
      maze[posX][posY] = 3;
      
      prevDir = choice.copy();
    }
  }
  
  int getPosX() {
    return posX;
  }
  
  int getPosY() {
    return posY;
  }
  
  void setPos(int x, int y) {
    posX = x;
    posY = y;
  }
}
