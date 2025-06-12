//Music: Relaxing Lofi - Tessera by Sascha Ende
//Link: https://filmmusic.io/en/song/12257-relaxing-lofi-tessera
import processing.sound.*;
private SoundFile backgroundMusic;
private SoundFile clickSFX;

private PFont font;

//screens 
private String currentScreen = "start"; 
private start startScreen;

//avatar for customization
private color[] hairColors = {#2E1802, #81552A, #FFD78B, #FA9A23, #FF81C6, #A881FF, #2A5EE8, #2AE8DA}; //black/dark brown, brown, blonde, ginger, pink, purple, dark blue, teal
private color[] skinColors = {#FFD8A7, #CBA575, #714C1E}; //light, tan, dark
private boolean hairSelectMode = false;
private boolean skinSelectMode = false;
private int currentHair = 0;
private int currentSkin = 0;
private avatar character;

//game
private game myGame;
private String gameDifficulty = "normal";

//result
private result myResult;

void setup() {
  size(800, 800);
  backgroundMusic = new SoundFile(this, "data/relaxing-lofi-tessera-by-sascha-ende-from-filmmusic-io.mp3");
  clickSFX = new SoundFile(this, "data/mouse-click-290204.mp3");
  backgroundMusic.loop();
  font = loadFont("TimesNewRomanPS-BoldMT-40.vlw");
  startScreen = new start();
  character = new avatar(hairColors[currentHair], skinColors[currentSkin]);
  myGame = new game(character, gameDifficulty);
}

void draw() {
  switch(currentScreen) {
    case "start":
      startScreen.drawStart();
      fill(#9c7e7e);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("difficulty: " + gameDifficulty, 400, 475);
      character.drawAvatar(205, 620, 225);
      break;
    case "game":
      if (myGame.getLives() <= 0 || myGame.isWin()) {myGame.setTimerRunning(false); currentScreen = "result";}
      else {myGame.drawMaze();}
      break;
    case "result":
      if (myGame.isWin())
      {
         myResult = new result(true, myGame);
         myResult.drawResult();
      }
      else 
      {
        myResult = new result(false, myGame);
        myResult.drawResult();
      }
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
     case "result":
       if (myResult.overButton(400, 500, 550, 100))
       {
         clickSFX.play(); 
         currentScreen = "start";
         character = new avatar(hairColors[currentHair], skinColors[currentSkin]);
         myGame = new game(character, gameDifficulty);
         myResult = null;
       }
       break;
  }
}

void keyPressed() {
  switch(currentScreen) {
    case "start":
      //customize modes
      if (key == '1') {gameDifficulty = "easy"; myGame = new game(character, gameDifficulty);} 
      if (key == '2') {gameDifficulty = "normal"; myGame = new game(character, gameDifficulty);} 
      if (key == '3') {gameDifficulty = "hard"; myGame = new game(character, gameDifficulty);}
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
      break;
    case "game":
      myGame.handleKeyPress(keyCode);
      break;
  }
}

 
