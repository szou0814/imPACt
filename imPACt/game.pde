import java.util.ArrayList;

public class game {
  int[][] maze;
  final int WALL = 0;
  final int SPACE = 1;
  final int AVATAR = 2;
  final int GHOSTS = 3;
  
  public game(int rows, int cols) {
    maze = new int[rows][cols];
  }
  
  //the following code is heavily drawn from the code that i wrote for lab 12: maze
  void drawMaze() {
    rectMode(CENTER);
    fill(250);
    square(0, 0, 1600);
    
    carveMaze();
  }
  
  void carveMaze() {
    
  }
  
  void carveMaze(int[][] maze, int row, int col) {
    if (row <= 0 || row >= maze.length - 1 || col <= 0 || col >= maze[row].length - 1) {return;}
    if (maze[row][col] == SPACE || checkAdjacent(maze, row, col)) {return;}
    
    maze[row][col] = SPACE;
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
    boolean ans = false;
    int count = 0;
    int[][] directions = {{row + 1, col}, {row - 1, col}, {row, col - 1}, {row, col + 1}};
    for (int[] dir : directions)
    {
        if (maze[dir[0]][dir[1]] != '#')
        {
            count++;
        }
    }
    if (count > 1)
    {
        ans = true;
    }
    return ans;
  }
}
