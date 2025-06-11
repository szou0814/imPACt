import java.util.ArrayList;

public class game {
  PFont fontBig;
  PFont fontSmall;
  
  boolean gameStart = false;
  boolean lifeLost = false;
  
  int startTime = 0;
  int totalElapsed = 0;
  boolean timerRunning = false;
  int ticks = 0;
  
  int[][] maze;
  int size = 40;
  final int WALL = 0;
  final int SPACE = 1;
  final int AVATAR = 2;
  final int GHOST = 3;
  final int FOOD = 4;
  
  ArrayList<ghost> ghosts = new ArrayList<ghost>();
  ArrayList<food> foods = new ArrayList<food>();
  avatar character;
 
  int lives = 3;
  PImage heartImg;
  
  public game(avatar character) {  
    this.character = character;
    fontBig = loadFont("TimesNewRomanPS-BoldMT-40.vlw");
    fontSmall = loadFont("TimesNewRomanPS-BoldMT-25.vlw");
    heartImg = loadImage("heart.png");
    maze = new int[21][18];
    carveMaze();
   
  }
  
  void drawMaze() {
    rectMode(CENTER);
    
    noStroke();
    fill(#fffcd3);
    square(0, 0, 1600);
  
    if (gameStart) {ticks++;}
    if (gameStart && ticks % 10 == 0) {updateGhosts();}
    if (gameStart && ticks % 12 == 0) {updateAvatar();}
    if (!gameStart && timerRunning) {totalElapsed += (millis() - startTime) / 1000; timerRunning = false;}
    
    for (food f : foods) 
    {
      f.drawFood(f.getPos().x * size, f.getPos().y * size, size  * 0.7);
    }
    
    for (int row = 0; row < maze.length; row++)
    {
      for (int col = 0; col < maze[row].length; col++)
      {
         if (maze[row][col] == AVATAR) {character.drawAvatar(row * size, col * size, size);}
         if (maze[row][col] == WALL) {noStroke(); fill(#ffc0cb); square(row * size, col * size, size);}
         
      }
    }
    
    for (ghost g : ghosts)
    {
      g.drawGhost(g.getPos().x * size, g.getPos().y * size, size);
    }
    
    if (!gameStart) 
    {      
      stroke(#e1f5fc);
      strokeWeight(5);
      fill(#ffedeb);
      rectMode(CENTER);
      rect(400, 360, 525, 140);

      fill(#fccde1);
      textAlign(CENTER, CENTER);
      textFont(fontBig);
      text("press any key to start", 400, 318);
      
      fill(#e3bbbc);
      textFont(fontSmall);
      if (!lifeLost)
      {
        text("your goal is to collect as many lines of code\nand achievements while avoiding the\nghosts of negative thought!", 400, 382);
      }
      else
      {
        if (lives == 1)
        {
          text("be careful now! you have just " + lives + " life left.\nyou can still do this!", 400, 375);
        }
        else
        {
          text("uh oh! you have " + lives + " lives left.\nyou got this. keep on going!", 400, 375);
        }
      }
    }
    
    drawStats();
  }
  
  void drawStats() {
    rectMode(CENTER);
    
    fill(#9c7e7e);
    textAlign(LEFT);
    textFont(fontSmall);
    text("lives left: ", 2, 722);
    for (int i = 0; i < lives; i++)
    {
      image(heartImg, 105 + i * 37, maze[0].length * size - 20, 30, 30);
    }
    
    text("time: " + getTime(), 2, 745);
  }
  
  void carveMaze() {
    carveMaze(maze, 1, 1);
    
    //ensure tunnels
    maze[0][maze[0].length / 2] = SPACE;
    maze[maze.length - 1][maze[0].length / 2] = SPACE;
    maze[maze.length / 2][0] = SPACE;
    maze[maze.length / 2][maze[0].length - 1] = SPACE;
    
    //ensure space for character
    maze[1][maze[0].length / 2] = AVATAR;
    maze[2][maze[0].length / 2] = SPACE;
    character.setPos(1, maze[0].length / 2);
    
    //ensure space for ghosts
    ghosts.clear();
    maze[maze.length / 2 - 1][maze[0].length / 2] = GHOST;
    maze[maze.length / 2][maze[0].length / 2] = GHOST;
    maze[maze.length / 2 + 1][maze[0].length / 2] = GHOST;
    
    ghosts.add(new ghost(maze.length / 2 - 1, maze[0].length / 2, true));
    ghosts.add(new ghost(maze.length / 2, maze[0].length / 2));
    ghosts.add(new ghost(maze.length / 2 + 1, maze[0].length / 2));
    
    //add food
    foods.clear();
    for (int r = 0; r < maze.length; r++)
    {
      for (int c = 0; c < maze[r].length; c++)
      {
        boolean isTunnel = (r == 0 && c == maze[0].length / 2) || (r == maze.length - 1 && c == maze[0].length / 2) || (r == maze.length / 2 && c == 0) || (r == maze.length / 2 && c == maze[0].length - 1);   
        if (!isTunnel && maze[r][c] == SPACE || maze[r][c] == GHOST) {foods.add(new food(r, c)); maze[r][c] = FOOD;}
      }
    }
  }
  
  void carveMaze(int[][] maze, int row, int col) {
    if (row <= 0 || row >= maze.length - 1 || col <= 0 || col >= maze[row].length - 1) {return;}
    if (maze[row][col] == SPACE || checkAdjacent(maze, row, col)) {return;}
    
    if (row == 1 && col == maze.length / 2) {return;}
    
    maze[row][col] = SPACE;
    foods.add(new food(row, col));
    ArrayList<Integer> directions = new ArrayList<Integer>();
    directions.add(0); directions.add(1); directions.add(2); directions.add(3);
    for (int i = 0; i < 4; i++)
    {
      int index = (int)(Math.random() * directions.size());
      int dir = directions.get(index);
      directions.remove(index);
      if (dir == 0) {carveMaze(maze, row - 1, col);}
      if (dir == 1) {carveMaze(maze, row + 1, col);}
      if (dir == 2) {carveMaze(maze, row, col - 1);}
      if (dir == 3) {carveMaze(maze, row, col + 1);}
    }
  }
  
  boolean checkAdjacent(int[][] maze, int row, int col) {
    int count = 0;
    int[][] directions = {{row + 1, col}, {row - 1, col}, {row, col - 1}, {row, col + 1}};
    for (int[] dir : directions)
    {
        if (dir[0] >= 0 && dir[0] < maze.length && dir[1] >= 0 && dir[1] < maze[0].length && maze[dir[0]][dir[1]] != WALL)
        {
            count++;
        }
    }
    return count > 1;
  }
  
  void handleKeyPress(int code) {
    if (!gameStart) 
    {
      if (!timerRunning)
      {
        startTime = millis();
        timerRunning = true;
      }
    }
    
    gameStart = true;
    lifeLost = false;
    
    if (code == UP) {character.setDir(0, -1);}
    if (code == DOWN) {character.setDir(0, 1);}
    if (code == LEFT) {character.setDir(-1, 0);}
    if (code == RIGHT) {character.setDir(1, 0);}
  }
  
  void updateAvatar() {
    PVector pos = character.getPos();
    PVector dir = character.getDir();
    
    int newX = (int)(pos.x + dir.x);
    int newY = (int)(pos.y + dir.y);
    
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
    
    if (newX >= 0 && newX < maze.length && newY >= 0 && newY < maze[0].length && maze[newX][newY] != WALL) {
      maze[(int)pos.x][(int)pos.y] = SPACE;
      maze[newX][newY] = AVATAR;
      character.setPos(newX, newY);
    }
  }
  
  void updateGhosts() {
    PVector avatarPos = character.getPos();
    
    for (ghost g : ghosts)
    {
      PVector prevPos = g.getPos().copy();
      g.move(maze, avatarPos);
      PVector currPos = g.getPos();
      
      if ((int)currPos.x == (int)avatarPos.x && (int)currPos.y == (int)avatarPos.y || (int)prevPos.x == (int)avatarPos.x && (int)prevPos.y == (int)avatarPos.y)
      {
        lives--;
        gameStart = false;
        lifeLost = true;
        resetAvatar();
        resetGhosts();
        return;
      }
    }
  }
  
  void resetAvatar() {
    maze[(int)character.getPos().x][(int)character.getPos().y] = SPACE;
    maze[1][maze[0].length / 2] = AVATAR;
    character.setPos(1, maze[0].length / 2);
  }
  
  void resetGhosts() {
    for (int i = -1; i <= 1; i++)
    {
      maze[(int)ghosts.get(i + 1).getPos().x][(int)ghosts.get(i + 1).getPos().y] = SPACE;
      ghosts.get(i + 1).setPos(maze.length / 2 + i, maze[0].length / 2);
      maze[maze.length / 2 + i][maze[0].length / 2] = GHOST;
    }
  }
  
  int getLives() {
    return lives;
  }
  
  String getTime() {
    int elapsed = totalElapsed;
    if (timerRunning) {
      elapsed += (millis() - startTime) / 1000;
    }
    
    return nf(elapsed / 60, 2) + ":" + nf(elapsed % 60, 2);
  }
}
  
