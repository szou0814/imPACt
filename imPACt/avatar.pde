public class avatar {
  color hairColor;
  color skinColor;
 
  public avatar(color hair, color skin) {
    hairColor = hair;
    skinColor = skin;
  }
  
  void drawAvatar(int x, int y, int size) {
    //back hair
    noStroke();
    fill(hairColor);
    square(x, y, size);
    
    //skin
    fill(skinColor);
    square(x, y + 5, size - 10);
    
    //bangs
    fill(hairColor);
    arc(x - 25, y - 25, 55, 55, 0, HALF_PI);
    arc(x + 25, y - 25, 55, 55, HALF_PI, PI);
    
    //eyes
    fill(0);
    square(x - 10, y + 5, 10);
    square(x + 10, y + 5, 10);
    fill(255);
    square(x - 13, y + 2, 4);
    square(x + 7, y + 2, 4);
    
  }
  
  void setHairColor(color hair) {
    hairColor = hair;
  }
  
  void setSkinColor(color skin) {
     skinColor = skin;
  }
  
}
