public class ghost {
  PVector pos;
  PVector prevDir = new PVector(0, 0);
  boolean isChaser;
  color ghostColor;
  
  public ghost(int x, int y) {
    pos = new PVector(x, y);
    ghostColor = color(random(255), random(255), random(255));
  }
  
  public ghost(int x, int y, boolean isChaser) {
    this(x, y);
    this.isChaser = isChaser;
  }
  
  void drawGhost(float x, float y, int size) {
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
  
  void move(int[][] maze, PVector avatarPos) {
    ArrayList<PVector> directions = new ArrayList<PVector>();
    PVector[] dirs = {new PVector(-1, 0), new PVector(1, 0), new PVector(0, -1), new PVector(0, 1)};
    if (isChaser)
    {
      for (int i = 0; i < dirs.length - 1; i++)
      {
        for (int j = i + 1; j < dirs.length; j++)
        {
          PVector nextI = PVector.add(pos, dirs[i]);
          PVector nextJ = PVector.add(pos, dirs[j]);
          float distI = PVector.dist(nextI, avatarPos);
          float distJ = PVector.dist(nextJ, avatarPos);
          
          if (distJ < distI) 
          {
            PVector temp = dirs[i];
            dirs[i] = dirs[j];
            dirs[j] = temp;
          }
        }
      }
    }
    else
    {
      for (int i = dirs.length - 1; i >= 0; i--)
      {
        int j = (int)(Math.random() * (i + 1));
        PVector temp = dirs[i];
        dirs[i] = dirs[j];
        dirs[j] = temp;
      }
    }

    for (PVector d : dirs) 
    {
      PVector newPos = PVector.add(pos, d);
      int newX = (int)newPos.x;
      int newY = (int)newPos.y;

      if ((int)pos.y == maze[0].length / 2) 
      {
        if (newX < 0) {newX = maze.length - 1;}
        else {if (newX >= maze.length) {newX = 0;}}
      }
      if ((int)pos.x == maze.length / 2) 
      {
        if (newY < 0) {newY = maze[0].length - 1;}
        else {if (newY >= maze[0].length) {newY = 0;}}
      }
      
      //WALL = 0
      //GHOST = 3
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
        PVector newPos = PVector.add(pos, d);
        int newX = (int)newPos.x;
        int newY = (int)newPos.y;
        
        if ((int)pos.y == maze[0].length / 2) 
        {
          if (newX < 0) {newX = maze.length - 1;}
          else {if (newX >= maze.length) {newX = 0;}}
        }
        if ((int)pos.x == maze.length / 2) 
        {
          if (newY < 0) {newY = maze[0].length - 1;}
          else {if (newY >= maze[0].length) {newY = 0;}}
        }
        
        if (newX >= 0 && newX < maze.length && newY >= 0 && newY < maze[0].length && maze[newX][newY] != 0 && maze[newX][newY] != 3) 
        {
          directions.add(d);
        }
      }
    }
    
    if (directions.size() > 0)
    {
      PVector choice = directions.get((int)random(directions.size()));
      int newX = (int)(pos.x + choice.x);
      int newY = (int)(pos.y + choice.y);
      
      if ((int)pos.y == maze[0].length / 2) 
      {
        if (newX < 0) {newX = maze.length - 1;}
        else {if (newX >= maze.length) {newX = 0;}}
      }
      if ((int)pos.x == maze.length / 2) 
      {
        if (newY < 0) {newY = maze[0].length - 1;}
        else {if (newY >= maze[0].length) {newY = 0;}}
      }
        
      maze[(int)pos.x][(int)pos.y] = 1;
      pos = new PVector(newX, newY);
      maze[(int)pos.x][(int)pos.y] = 3;
      
      prevDir = choice.copy();
    }
  }
  
  PVector getPos() {
    return pos.copy();
  }
  
  void setPos(float x, float y) {
    pos = new PVector(x, y);
  }
}
