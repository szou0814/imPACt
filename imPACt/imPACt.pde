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

//avatar 
color[] hairColors = {#2E1802, #81552A, #FFD78B, #FA9A23, #FF81C6, #A881FF, #2A5EE8, #2AE8DA}; //black/dark brown, brown, blonde, ginger, pink, purple, dark blue, teal
color[] skinColors = {#FFD8A7, #CBA575, #714C1E}; //light, tan, dark
int currentHair = 0;
int currentSkin = 0;
avatar character;

void setup() {
  size(800, 800);
  backgroundMusic = new SoundFile(this, "data/relaxing-lofi-tessera-by-sascha-ende-from-filmmusic-io.mp3");
  clickSFX = new SoundFile(this, "data/mouse-click-290204.mp3");
  backgroundMusic.loop();
  startScreen = new start();
  character = new avatar(hairColors[currentHair], skinColors[currentSkin]);
}

void draw() {
  switch(currentScreen) {
    case "start":
      startScreen.drawStart();
      character.drawAvatar();
      break;
    case "game":
      break;
    //case "avatar":
      //break;
  }
  
}

void mousePressed() {
  //from start to game
  if (startScreen.overButton(400, 400, 550, 100)) {clickSFX.play(); currentScreen = "game";}
  //from start to customize 
  //if (startScreen.overButton(400, 630, 550, 150)) {currentScreen = "customize";}
}
 
