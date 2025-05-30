//Music: Relaxing Lofi - Tessera by Sascha Ende
//Link: https://filmmusic.io/en/song/12257-relaxing-lofi-tessera
import processing.sound.*;
SoundFile backgroundMusic;
SoundFile clickSFX;

//text font
PFont font;
PImage start;

//screens 
String currentScreen = "start"; 
start startScreen;

//avatar for customization
color[] hairColors = {#2E1802, #81552A, #FFD78B, #FA9A23, #FF81C6, #A881FF, #2A5EE8, #2AE8DA}; //black/dark brown, brown, blonde, ginger, pink, purple, dark blue, teal
color[] skinColors = {#FFD8A7, #CBA575, #714C1E}; //light, tan, dark
boolean hairSelectMode = false;
boolean skinSelectMode = false;
int currentHair = 0;
int currentSkin = 0;
avatar character;

//ghost
ghost myGhost;

//game
game myGame;

//food
food myFood;

void setup() {
  size(800, 800);
  //backgroundMusic = new SoundFile(this, "data/relaxing-lofi-tessera-by-sascha-ende-from-filmmusic-io.mp3");
  clickSFX = new SoundFile(this, "data/mouse-click-290204.mp3");
  //backgroundMusic.loop();
  startScreen = new start();
  myGhost = new ghost();
  myGame = new game(width / 40, width / 40);
  myFood = new food();
  character = new avatar(hairColors[currentHair], skinColors[currentSkin]);
}

void draw() {
  switch(currentScreen) {
    case "start":
      startScreen.drawStart();
      character.drawAvatar(400, 600, 225);
      break;
    case "game":
      myGame.drawMaze();
      myGhost.drawGhost(400, 600, 225);
      myFood.drawFood(400, 300, 225);
      break;
  }
}

void mousePressed() {
  //from start to game
  switch(currentScreen) {
     case "start":
       if (startScreen.overButton(400, 400, 550, 100)) {clickSFX.play(); currentScreen = "game";}
       break;
     case "game":
       break;
  }
}

void keyPressed() {
  switch(currentScreen) {
    case "start":
      //customize modes
      if (key == 'h') {hairSelectMode = true; skinSelectMode = false;}
      if (key == 's') {hairSelectMode = false; skinSelectMode = true;}
      //change hair
      if (hairSelectMode)
      {
         if (keyCode == LEFT) {currentHair = (currentHair + hairColors.length - 1) % hairColors.length;}
         if (keyCode == RIGHT) {currentHair = (currentHair + 1) % hairColors.length;}
         character.setHairColor(hairColors[currentHair]);
      }
      //change skin
      if (skinSelectMode) 
      {
         if (keyCode == LEFT) {currentSkin = (currentSkin + skinColors.length - 1) % skinColors.length;}
         if (keyCode == RIGHT) {currentSkin = (currentSkin + 1) % skinColors.length;}
         character.setSkinColor(skinColors[currentSkin]);
      }
  }
}

 
