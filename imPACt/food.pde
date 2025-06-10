public class food {
 PVector pos;
 String type;
 int powerupDuration;
 
 public food(int x, int y) {
   pos = new PVector(x, y);
   
   //deciding what type
   int chancePowerup = (int)(Math.random() * 100);
   if (chancePowerup < 95) {type = "normal"; powerupDuration = 0;}
   else {type = "powerUp"; powerupDuration = 10;}
 }
 
 void drawFood(float x, float y, float size) {
   rectMode(CENTER);

   if (type.equals("normal"))
   {
     //laptop
     noStroke();
     fill(#e1f5fc);
     rect(x, y - (size * 0.1), size, size * 0.7);
     fill(#b6ecff);
     rect(x, y + (size * 0.3), size, size * 0.2);
     fill(250);
     rect(x, y - (size * 0.1), size * 0.9, size * 0.6, 15);
     stroke(#b6ffba);
     strokeWeight(size * 0.03);
     for (int i = 1; i < 7; i++)
     {
       float lineLength = size * (0.3 * (i % 3) + 0.2);
       line(x - (size * 0.4), y - (size * 0.4) + (size * (0.08 * i)), x - (size * 0.4) + lineLength, y - (size * 0.4) + (size * (0.08 * i)));
     }
   }
   if (type.equals("powerUp"))
   {
     //medal
     noStroke();
     fill(#ffc0cb);
     rect(x, y - (size * 0.22), size * 0.3, size * 0.56);
     fill(#fce5ef);
     rect(x, y - (size * 0.22), size * 0.15, size * 0.56);
     fill(#fff573);
     circle(x, y + (size * 0.25), size * 0.50);
     fill(#fffcd3);
     circle(x, y + (size * 0.25), size * 0.38);
     fill(#fff573);
     textAlign(CENTER, CENTER);
     textSize(size * 0.3);
     text("#1", x, y + (size * 0.25));
   }
 }
 
   PVector getPos() {
    return pos.copy();
  }
  
  void setPos(float x, float y) {
    pos.set(x, y);
  }
}
