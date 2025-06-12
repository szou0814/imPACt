import java.util.ArrayList;

public class game {
  private PFont fontBig;
  private PFont fontSmall;
  
  private boolean gameStart = false;
  private boolean lifeLost = false;
  private String difficulty;
  
  private int startTime = 0;
  private int totalElapsed = 0;
  private boolean timerRunning = false;
  private int ticks = 0;
  private int score = 0;
  
  private int[][] maze;
  private int size = 40;
  private final int WALL = 0;
  private final int SPACE = 1;
  private final int AVATAR = 2;
  private final int GHOST = 3;
  private final int FOOD = 4;
  
  private ArrayList<ghost> ghosts = new ArrayList<ghost>();
  private ArrayList<food> foods = new ArrayList<food>();
  private int numGhosts;
  private int ghostBound;
  private avatar character;
 
  private int lives;
  private int avatarTicks;
  private int ghostTicks;
  private int totalFood = 0;
  private PImage heartImg;
  
  private boolean isImmune = false;
  private int immuneStart = 0;
  private int immuneDuration = 0;
  private int timeImmune = 0;
  private boolean isMultiplied = false;
  private int scoreMultiplier = 1;
  private int multiplyStart = 0;
  private int multiplyDuration = 0;
  private int timeMultiplied = 0;
  
  private int level = 1; //3 levels max
  private boolean levelTransition = false;
  
  public game(avatar character, String difficulty) {  
    this.character = character;
    this.difficulty = difficulty;
    if (difficulty.equals("easy")) {numGhosts = 2; lives = 5; ghostTicks = 15; avatarTicks = 10;}
    if (difficulty.equals("normal")) {numGhosts = 3; lives = 3; ghostTicks = 11; avatarTicks = 10;}
    if (difficulty.equals("hard")) {numGhosts = 4; lives = 2; ghostTicks = 7; avatarTicks = 10;}
    
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
    
    if (foods.size() == 0 && lives > 0 && level <= 3 && !levelTransition)
    {
      level++;
      levelTransition = true;
      gameStart = false;
      timerRunning = false;
      isImmune = false;
      isMultiplied = false;
      timeImmune = 0;
      timeMultiplied = 0;
      scoreMultiplier = 1;
      nextLevel();
    }
      
    if (isImmune && ((millis() - immuneStart) > immuneDuration)) {isImmune = false;}
    if (isMultiplied && ((millis() - multiplyStart) > multiplyDuration)) {isMultiplied = false; scoreMultiplier = 1;}
    
    if (gameStart) {ticks++;}
    if (gameStart && ticks % ghostTicks == 0) {updateGhosts();}
    if (gameStart && ticks % avatarTicks == 0) {updateAvatar();}
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
      text("level " + level + ": press any key to start", 400, 318);
      
      fill(#e3bbbc);
      textFont(fontSmall);
      if (!lifeLost)
      {
        if (level == 1) 
        {
          text("your goal is to collect all the lines of code and\nachievements while avoiding the ghosts\n of negative thought. good luck!", 400, 382);
        }
        else
        {
          text("congrats! you advanced to the next level.\nyou are doing amazing!", 400, 375);
        }
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
    text("lives left: ", 2, 730);
    for (int i = 0; i < lives; i++)
    {
      image(heartImg, 105 + i * 37, maze[0].length * size - 15, 30, 30);
    }
    
    text("time: " + getTime(), 2, 755);
    text("score: " + score, 2, 780);
    if (isImmune) {timeImmune = (immuneDuration - (millis() - immuneStart)) / 1000;}
    else {timeImmune = 0;}
    text("immunity time left: " + timeImmune + "s", 145, 755);
    if (isMultiplied) {timeMultiplied = (multiplyDuration - (millis() - multiplyStart)) / 1000;}
    else {timeMultiplied = 0;}
    text("score multiplier time left: " + scoreMultiplier + "x " + timeMultiplied + "s", 145, 780);
    
    rectMode(CORNER);
    noStroke();
    fill(255);
    rect(510, 714, 260, 70);
    fill(#e1f5fc);
    rect(510, 714, ((float)(totalFood - foods.size()) / totalFood) * 260, 70);
    stroke(#fccde1);
    strokeWeight(5);
    noFill();
    rect(510, 714, 260, 70);
    fill(#9c7e7e);
    text("" + (int)(((float)(totalFood - foods.size()) / totalFood) * 100) + "%", 635, 755);
  }
  
  void carveMaze() {
    carveMaze(maze, 1, 1);
    
    //ensure tunnels
    maze[0][maze[0].length / 2] = SPACE;
    maze[maze.length - 1][maze[0].length / 2] = SPACE;
    maze[maze.length / 2][0] = SPACE;
    maze[maze.length / 2][maze[0].length - 1] = SPACE;
    
    for (int r = 0; r < 5; r++) {maze[r][maze[0].length / 2] = SPACE;}
    for (int r = maze.length - 1; r > maze.length - 6; r--) {maze[r][maze[0].length / 2] = SPACE;}
    for (int c = 0; c < 5; c++) {maze[maze.length / 2][c] = SPACE;}
    for (int c = maze[0].length - 1; c > maze[0].length - 6; c--) {maze[maze.length / 2][c] = SPACE;}
    
    //ensure space for character
    for (int r = 0; r < maze.length; r++)
    {
      for (int c = 0; c < maze[0].length; c++)
      {
        if (maze[r][c] == AVATAR) {maze[r][c] = SPACE;}
      }
    }
    maze[1][maze[0].length / 2] = AVATAR;
    maze[2][maze[0].length / 2] = SPACE;
    character.setPos(1, maze[0].length / 2);
    
    //ensure space for ghosts
    ghosts.clear();
    if (numGhosts % 2 != 0) {ghostBound = numGhosts/2;}
    else {ghostBound = (numGhosts / 2) - 1;}
    
    for (int i = -(numGhosts / 2); i <= ghostBound; i++)
    {
      maze[maze.length / 2 + i][maze[0].length / 2] = GHOST;
      if (i == 0) {ghosts.add(new ghost(maze.length / 2, maze[0].length / 2));}
      else {ghosts.add(new ghost(maze.length / 2 + i, maze[0].length / 2));}
    }
   
    //add food
    foods.clear();
    totalFood = 0;
    for (int r = 0; r < maze.length; r++)
    {
      for (int c = 0; c < maze[r].length; c++)
      {
        boolean isTunnel = (r == 0 && c == maze[0].length / 2) || (r == maze.length - 1 && c == maze[0].length / 2) || (r == maze.length / 2 && c == 0) || (r == maze.length / 2 && c == maze[0].length - 1);   
        if (!isTunnel && maze[r][c] == SPACE || maze[r][c] == GHOST) {foods.add(new food(r, c, difficulty)); maze[r][c] = FOOD; totalFood++;}
      }
    }
  }
  
  private void carveMaze(int[][] maze, int row, int col) {
    if (row <= 0 || row >= maze.length - 1 || col <= 0 || col >= maze[row].length - 1) {return;}
    if (maze[row][col] == SPACE || checkAdjacent(maze, row, col)) {return;}
    
    if (row == 1 && col == maze.length / 2) {return;}
    
    maze[row][col] = SPACE;
    foods.add(new food(row, col, difficulty));
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
  
 private boolean checkAdjacent(int[][] maze, int row, int col) {
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
    if (levelTransition)
    {
      levelTransition = false;
      return;     
    }
    
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

      for (int i = foods.size() - 1; i >= 0; i--) 
      {
        if ((int)foods.get(i).getPos().x == newX && (int)foods.get(i).getPos().y == newY) 
        {
          score += scoreMultiplier * foods.get(i).getValue();
          if (foods.get(i).isPowerup())
          {
            int whichPower = (int)(Math.random() * 100);
            if (whichPower < 50) 
            {
              isImmune = true;
              immuneStart = millis();
              immuneDuration = foods.get(i).getPowerupDuration();
            }
            else 
            {
              isMultiplied = true;
              multiplyStart = millis();
              multiplyDuration = foods.get(i).getPowerupDuration();
              if (scoreMultiplier < 4) {scoreMultiplier *= 2;}
            }
          }
          foods.remove(i);
          break;
        }
      }
      maze[newX][newY] = AVATAR;
      character.setPos(newX, newY);
    }
  }
  
  void updateGhosts() {
    PVector avatarPos = character.getPos();
    
    for (ghost g : ghosts)
    {
      if (isImmune && !g.isDisabled()) {g.setIsScared(true);}
      else {g.setIsScared(false);}
      
      PVector prevPos = g.getPos().copy();
      g.move(maze, avatarPos);
      PVector currPos = g.getPos();
      
      if ((int)currPos.x == (int)avatarPos.x && (int)currPos.y == (int)avatarPos.y || (int)prevPos.x == (int)avatarPos.x && (int)prevPos.y == (int)avatarPos.y)
      {
        if (isImmune && !g.isDisabled()) 
        {
          score += scoreMultiplier * 200;
          maze[(int)currPos.x][(int)currPos.y] = AVATAR;
          character.setPos(currPos.x, currPos.y);
          g.powerupDisabled();
          g.setIsScared(false);
        }
        else
        {
          lives--;
          gameStart = false;
          lifeLost = true;
          isImmune = false;
          isMultiplied = false;
          timeImmune = 0;
          timeMultiplied = 0;
          scoreMultiplier = 1;
          resetAvatar();
          resetGhosts();
          return;
        }
      }
    }
  }
  
  void resetAvatar() {
    maze[(int)character.getPos().x][(int)character.getPos().y] = SPACE;
    maze[1][maze[0].length / 2] = AVATAR;
    character.setPos(1, maze[0].length / 2);
  }
  
  void resetGhosts() {
    int index = 0;
    for (int i = -(numGhosts / 2); i <= ghostBound; i++)
    {
      maze[(int)ghosts.get(index).getPos().x][(int)ghosts.get(index).getPos().y] = SPACE;
      ghosts.get(index).setPos(maze.length / 2 + i, maze[0].length / 2);
      maze[maze.length / 2 + i][maze[0].length / 2] = GHOST;
      
      index++;
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
  
  int getScore() {
    return score;
  }
  
  void setTimerRunning(boolean running) {
    timerRunning = running;
  }
  
  boolean isWin() {
    if (level > 3) {return true;}
    else {return false;}
  }
  
  void nextLevel() {
    if (level == 3) {numGhosts++;}
    ghostTicks--;
    foods.clear();
    totalFood = 0;
    carveMaze();
    resetAvatar();
    resetGhosts();
    startTime = millis();
    timerRunning = true;
  }

}
  
