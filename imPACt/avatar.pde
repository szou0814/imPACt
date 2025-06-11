public class avatar {
  private PVector pos;
  private PVector dir;
  private color hairColor;
  private color skinColor;
 
  public avatar(color hair, color skin) {
    pos = new PVector(0, 0);
    dir = new PVector(0, 0);
    hairColor = hair;
    skinColor = skin;
  }
  
  void drawAvatar(float x, float y, int size) {
    //back hair
    noStroke();
    fill(hairColor);
    square(x, y, size);
    
    //skin
    fill(skinColor);
    square(x, y + (size * 0.1), size - (size * 0.2));
    
    //bangs
    fill(hairColor);
    arc(x - (size * 0.5), y - (size * 0.5), size * 1.1, size * 1.1, 0, HALF_PI);
    arc(x + (size * 0.5), y - (size * 0.5), size * 1.1, size * 1.1, HALF_PI, PI);
    
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
    
    //smile
    noFill();
    stroke(0);
    strokeWeight(size * 0.05);
    arc(x, y + size * 0.30, size * 0.20, size * 0.15, 0, PI);
    
    //clip
    pushMatrix();
    translate(x - (size * 0.3), y - (size * 0.25));
    rotate(-PI/6);
    noStroke();
    fill(#fffcd3);
    rectMode(CENTER);
    rect(0, 0, size * 0.25, size * 0.1);
    popMatrix();

  }
  
  PVector getPos() {
    return pos.copy();
  }
  
  PVector getDir() {
    return dir.copy();
  }

  void setPos(float x, float y) {
    pos.set(x, y);
  }
  
  void setDir(float x, float y) {
    dir.set(x, y);
  }
  
  void setHairColor(color hair) {
    hairColor = hair;
  }
  
  void setSkinColor(color skin) {
    skinColor = skin;
  }
  
}
