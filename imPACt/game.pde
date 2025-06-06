import java.util.ArrayList;

public class game {
  int ticks = 0;
  
  int[][] maze;
  int size = 40;
  avatar character;
  //temp
  ghost ghost1;
  ghost ghost2;
  final int WALL = 0;
  final int SPACE = 1;
  final int AVATAR = 2;
  final int GHOST = 3;
  final int FOOD = 4;
  
  ArrayList<food> foods = new ArrayList<food>();
  
  public game(avatar character) {  
    this.character = character;
    maze = new int[21][21];
    carveMaze();
   
  }
  
  void drawMaze() {
    ticks++;
    rectMode(CENTER);
    
    //background
    noStroke();
    fill(#fffcd3);
    square(0, 0, 1600);
    
    if (ticks % 10 == 0) {updateGhosts();}
    
    //maze
    for (int row = 0; row < maze.length; row++)
    {
      for (int col = 0; col < maze[row].length; col++)
      {
         //avatar
         if (maze[row][col] == AVATAR) {character.drawAvatar(row * size, col * size, size);}
         //wall
         if (maze[row][col] == WALL) {fill(#ffc0cb); square(row * size, col * size, size);}
         
      }
    }
    
    for (food f : foods) 
    {
      f.drawFood(f.getPosX() * size, f.getPosY() * size, size * 0.7);
    }
    
    //temp
    ghost1.drawGhost(ghost1.getPosX() * size, ghost1.getPosY() * size, size);
    ghost2.drawGhost(ghost2.getPosX() * size, ghost2.getPosY() * size, size);
  }
  
  void carveMaze() {
    carveMaze(maze, 1, 1);
    
    //ensure space for character
    maze[1][maze.length / 2] = AVATAR;
    maze[2][maze.length / 2] = SPACE;
    character.setPos(1, maze.length / 2);
    
    maze[19][maze.length / 2 - 1] = GHOST;
    maze[19][maze.length / 2 + 1] = GHOST;
    
    //temp
    ghost1 = new ghost(19, maze.length / 2 - 1);
    ghost2 = new ghost(19, maze.length / 2 + 1);
    
    
   
  }
  
  void carveMaze(int[][] maze, int row, int col) {
    if (row <= 0 || row >= maze.length - 1 || col <= 0 || col >= maze[row].length - 1) {return;}
    if (maze[row][col] == SPACE || checkAdjacent(maze, row, col)) {return;}
    
    if (row == 1 && col == maze.length / 2) {return;}
    //temp
    if (row == 19 && (col == maze.length / 2 - 1 || col == maze.length / 2 + 1)) {return;}
    
    maze[row][col] = FOOD;
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
    int x = character.getPosX();
    int y = character.getPosY();
    int newX = x;
    int newY = y;
    
    if (code == UP) {newY--;}
    if (code == DOWN) {newY++;}
    if (code == LEFT) {newX--;}
    if (code == RIGHT) {newX++;}
    
    if (newX >= 0 && newX < maze.length && newY >= 0 && newY < maze[0].length && maze[newX][newY] != WALL) {
      maze[x][y] = SPACE;
      maze[newX][newY] = AVATAR;
      character.setPos(newX, newY);
    }
  }
  
  void updateGhosts() {
    ghost1.move(maze);
    ghost2.move(maze);
  }
}
