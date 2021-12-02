// current 11/28/21
//sound 
//import processing.sound.*;
//SoundFile backgroundMusic;

//handshaking vars 
import processing.serial.*;
boolean firstContact = false;

// NEOPIXEL MATRIX
String portName = "COM3";
Serial port = new Serial(this, portName, 9600);

// score vars
int prevScore1=0;
int prevScore2=0;
int prevScoreAuto=0;
int prevScore5=0;

//PLAYER 1 HANDLE
//BLUE
String portName1 = "COM8";
Serial port1 = new Serial(this, portName1, 9600);

// first contact stuff
boolean firstContact1 = false;

// my message variable
String message1;
//String outMessage1;
//int quadrant;

// my parsed vars from the message
int p1Val1 = 500; // joystick x
int p1Val2= 500; //joystick y
int p1Val3=1; //joystick button
int p1Val4; // accelerometer boolean (swung)
//0 == false    1 == true

int xThreshHigh = 750;
int xThreshLow = 250;
int yThreshHigh = 250;
int yThreshLow = 600;
int standardThresh = 1;

boolean right=false;
boolean left = true;
boolean up = true;
boolean down=false;


//PLAYER 2 HANDLE
//GREEN
String portName2 = "COM14"; 
Serial port2 = new Serial(this, portName2, 9600);

// first contact stuff
boolean firstContact2 = false;

// my message variable
String message2;
//String outMessage2;
//int quadrant;

// my parsed vars from the message
int p2Val1 = 500;
int p2Val2 = 500;
int p2Val3 = 1;
int p2Val4;


// background images
PImage singleCourtImg;
PImage doubleCourtImg;
PImage homeScreenImg;
//PImage instructionScreenImg;
PImage creditScreenImg;

// making an individual player
Player p1;
Player p2;
Player p3;
Player p4;
Player p5;

//making an individual ball
Ball b1;
Ball b2;
Ball b3;

// making an individual automatic player
Automatic a1;

//homescreen hitboxes
int singleHomeX;
int singleHomeY;
int singleHomeWidth;
int singleHomeHeight;

int multiHomeX;
int multiHomeY;
int multiHomeWidth;
int multiHomeHeight;

int instructionHomeX;
int instructionHomeY;
int instructionHomeWidth;
int instructionHomeHeight;

int creditHomeX;
int creditHomeY;
int creditHomeWidth;
int creditHomeHeight;

// score for the player to win
int winningScore; 

// varible to change the state of the game
int state = 0;

//Animation stuff
Animation pickler;

// make an array of puncher Images
// makes the array have 2 slots
PImage[] picklerImages = new PImage[2];

void setup() {
  size(1200, 600);

  //backgroundMusic = new SoundFile(this,

  // background image for single player
  singleCourtImg = loadImage("Court10.png");
  singleCourtImg.resize(1200, 600);

  //background image for multiplayer
  doubleCourtImg = loadImage("Court20.png");
  doubleCourtImg.resize(1200, 600);

  //background image for homescreen
  homeScreenImg = loadImage("Image-1.jpg");
  homeScreenImg.resize(1200, 600);

  //background image for instruction screen
  //instructionScreenImg = loadImage
  //instructionScreenImg.resize

  //background image for credits
  creditScreenImg = loadImage("credits.JPG");
  creditScreenImg.resize(1200, 600);

  // score for the player to win
  winningScore = 5;

  //multiplayer player mode
  //
  //players
  p1 = new Player(width/8, 40, color(0, 0, 255), width-100, height - 40, winningScore );
  p2 = new Player(width/2 - width/8, height - 40, color(0, 255, 0), 50, height - 40, winningScore);
  //reflection of p1
  //left side
  p3 = new Player(width - width/8 - p1.w, height-40, p1.c, p1.scoreX, p1.scoreY, winningScore);
  //reflection of p2
  p4 = new Player (width/2 + width/8 - p2.w, 40, p2.c, p2.scoreX, p2.scoreY, winningScore);
  //ball
  b2 = new Ball(p1.x, p1.y);
  b3 = new Ball(p3.x, p3.y);


  //single player mode
  //
  //players
  p5 = new Player(width-width/4, height - 40, color(0, 0, 255), width - 100, height - 40, winningScore);
  // automatic player
  a1 = new Automatic(width/4, 40, color(255, 0, 255), 50, height - 40, winningScore, 0.9, 0.6);
  //ball
  b1 = new Ball(p5.x, p5.y);


  //hitboxes for homescreen
  //singleplayer
  singleHomeX = 20;
  singleHomeY = 20;
  singleHomeWidth = 500;
  singleHomeHeight = 150;

  //instructions
  instructionHomeX = 20;
  instructionHomeY = height - 110;
  instructionHomeWidth = 500;
  instructionHomeHeight = 100;

  //multiplayer
  multiHomeX = width - 500;
  multiHomeY = 25;
  multiHomeWidth = 475;
  multiHomeHeight = 125;

  //credits
  creditHomeX = width - 300;
  creditHomeY = height - 125;
  creditHomeWidth = 275;
  creditHomeHeight = 100;



  //fill the array with images from the data folder
  for (int i=0; i<picklerImages.length; i++) {
    picklerImages[i] = loadImage("pickler"+i+".png");
  }

  pickler = new Animation(picklerImages, .2, 1);

  serialEvent(port);
  serialEvent1(port1);
  serialEvent2(port2);

  if (port.available() > 0) {
    port.write("?0,0!");
  }
}

void draw() {
  buttonSelect();
  switch (state) {
    // start screen
  case 0:
    imageMode(CORNER);
    //if (backgroundMusic.isPlaying() == false) {
    //  backgroundMusic.play();
    //}

    image(homeScreenImg, 0, 0);

    break;


  case 1:

    // single player mode
    // draw my image
    image(singleCourtImg, 0, 0);
    // recieve1();
    // recieve2();
    move();

    p5.render();
    p5.moveLeft();
    p5.moveRight();
    p5.scoring(b1);

    a1.render();
    a1.ease(b1);
    a1.hit(b1);
    a1.scoring(b1);

    b1.render();
    b1.move();
    b1.ballWallDetect();

    // addd 1 to p2 score if they won the point
    if (b1.y <= b1.d) {
      p5.score = p5.score + 1;
      a1.x = int(width/4);
      p5.x = width - width/4;
      delay(1000);
      b1.x = p5.x;
      b1.y = p5.y;
    }

    // add 1 to a1 score if they won the point
    if (b1.y - b1.d/2 >= height) {
      a1.score = a1.score + 1;
      a1.x = int(width/4);
      p5.x = width - width/4;
      delay(1000);
      b1.x = int(a1.x);
      b1.y = int(a1.y);
    }

    break;

  case 2:
    // mutltiplayer mode
    image(doubleCourtImg, 600, 300);

    //dividing line 
    line (width/2, 0, width/2, height);
    //recieve1();
    //recieve2();
    move();

    p1.render();
    p1.moveLeft1();
    p1.moveRight1();
    p1.scoring(b2);

    pickler.display(p2.x + 20, p2.y);
    p2.render();
    p2.moveLeft1();
    p2.moveRight1();
    p2.scoring(b2); 

    p3.render();
    p3.moveLeft2();
    p3.moveRight2();
    p3.scoring(b3);

    p4.render();
    p4.moveLeft2();
    p4.moveRight2();
    p4.scoring(b3);

    b2.render();
    b2.move1();
    b2.x = width - b3.x;
    b2.y = height - b3.y;
    b2.ballWallDetect1();

    b3.render();
    b3.move();
    b3.ballWallDetect2();

    // add 1 to p1/p3 score if they won the point
    if (b2.y - b2.d/2 >= height  && b3.y <= b3.d/2) {
      p1.score = p1.score + 1;
      p3.score = p3.score + 1;
      p1.x = width/8;
      p3.x = width - width/8 - p1.w;
      p2.x = width/2 - width/8;
      p4.x = width/2 + width/8 - p2.w;
      delay(1000);
      b2.x = p1.x;
      b2.y = p1.y;
      b3.x = p3.x;
      b3.y = p3.y;
    }

    // addd 1 to p2/p4 score if they won the point
    if (b2.y <= b2.d && b3.y - b3.d/2 >= height) {
      p2.score = p2.score + 1;
      p4.score = p4.score + 1;
      p1.x = width/8;
      p3.x = width - width/8 - p1.w;
      p2.x = width/2 - width/8;
      p4.x = width/2 + width/8 - p2.w;
      delay(1000);
      b2.x = p2.x;
      b2.y = p2.y;
      b3.x = p4.x;
      b3.y = p4.y;
    }


    if (p1.score != prevScore1 || p2.score != prevScore2) {
      sendMessageP();
    }

    break;

  case 3:
    //credits
    image(creditScreenImg, 0, 0);

    break;

  case 4:
    // instructions
    background(42);
    textSize (128);
    text ("Instructions", width/5, height/4);

    break;
  }

  prevScore1 = p1.score;
  prevScore2 = p2.score;
  prevScoreAuto = a1.score;
  prevScore5 = p5.score;
}

void sendMessageP() {
  char startChar = '?';
  char endChar = '!';
  port.write(startChar+str(p1.score)+","+(p2.score)+endChar);
  println(p1.score + "\t" + p2.score);
} 

void sendMessageA() {
  char startChar = '?';
  char endChar = '!';
  port.write(startChar+str(15)+","+(p5.score)+endChar);
  println(a1.score + "\t" + p5.score);
} 

// return true if the first input is between the two given numbers
// otherwise return false
boolean isBetween(int aNum, int lowerBound, int upperBound) {
  if (aNum > lowerBound && aNum < upperBound) {
    return true;
  } else {
    return false;
  }
}

// return true if the mouse is currently in the bounds of the button
// whose values you gave as inputs
boolean isInButton(int xButton, int yButton, int widthButton, int heightButton) {
  if (mouseX > xButton && mouseX < xButton + widthButton &&
    mouseY > yButton && mouseY < yButton + heightButton) {
    isBetween (mouseX, xButton, xButton + widthButton);
    isBetween (mouseY, yButton, yButton + heightButton);
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (isInButton (singleHomeX, singleHomeY, singleHomeWidth, singleHomeHeight)) {
    if (state == 3) {
      state = 0;
    } else {
      // initialize
      setup();
      state=1;
    }
  }
  if (isInButton (multiHomeX, multiHomeY, multiHomeWidth, multiHomeHeight)) {
    // initialize
    setup();
    state=2;
  }
  if (isInButton (creditHomeX, creditHomeY, creditHomeWidth, creditHomeHeight)) {
    // initialize
    setup();
    state=3;
  }
  if (isInButton (instructionHomeX, instructionHomeY, instructionHomeWidth, instructionHomeHeight)) {
    // initialize
    setup();
    state=4;
  }
}


void keyPressed() {
  if (key == 'a') {
    p2.isMovingLeft = true;
    p4.isMovingRight = true;
  }
  if (key == 'd') {
    p2.isMovingRight = true;
    p4.isMovingLeft = true;
  }
  if (key == 'w') {
    //p2.swing2(b2);
    pickler.isAnimating = true;
    p4.swing(b3);
  }
  if (key == CODED) {
    if (keyCode == LEFT) {
      p3.isMovingLeft = true;
      p1.isMovingRight = true;
      p5.isMovingLeft = true;
    }
    if (keyCode == RIGHT) {
      p3.isMovingRight = true;
      p1.isMovingLeft = true;
      p5.isMovingRight = true;
    }
  }

  //states 
  if (key == 'h') {
    //initialize
    setup();
    state = 0;
  }
}

void keyReleased() {
  if (key == 'a') {
    p2.isMovingLeft = false;
    p4.isMovingRight = false;
  }
  if (key == 'd') {
    p2.isMovingRight = false;
    p4.isMovingLeft = false;
  }
  if (key == CODED) {
    if (keyCode == LEFT) {
      p1.isMovingRight = false;
      p3.isMovingLeft = false;
      p5.isMovingLeft = false;
    }
    if (keyCode == RIGHT) {
      p1.isMovingLeft = false;
      p3.isMovingRight = false;
      p5.isMovingRight = false;
    }
    if (keyCode == UP) {
      //p1.swing(b2);
      p3.swing(b3);
      p5.swing(b1);
    }
  }
}

void move() {
  recieve1();
  recieve2();
  if (p1Val1 >= xThreshHigh) {
    /* p1.isMovingRight = true;
     p3.isMovingRight = true;
     p5.isMovingRight = true;*/
    p3.isMovingRight = true;
    p1.isMovingLeft = true;
    p5.isMovingRight = true;
  }
  if (p1Val1 <= xThreshLow) {
    /* p1.isMovingLeft = true;
     p3.isMovingLeft = true;
     p5.isMovingLeft = true;*/
    p3.isMovingLeft = true;
    p1.isMovingRight = true;
    p5.isMovingLeft = true;
  }

  if (p1Val1 > 400 && p1Val1 < 600) {
    p1.isMovingLeft = false;
    p1.isMovingRight = false;
    p3.isMovingLeft = false;
    p3.isMovingRight = false;

    p5.isMovingLeft = false;
    p5.isMovingRight = false;
  }

  if (p1Val3 == 0) {
    // TODO: ADD CASE NUMBERS-> WHAT HAPPENS WHEN BUTTON IS PRESSED
    p1Val3=1;
  }

  if (p1Val4 == 1) {
    p1.swing(b2);
    p3.swing(b3);
    p5.swing(b1);
    p1.collided = false; 
    p3.collided = false;
    p5.collided = false;
  }

  if (p2Val1 >= xThreshHigh) {
    p2.isMovingRight = true;
    p4.isMovingLeft = true;
    println("moving right");
  }
  if (p2Val1 <= xThreshLow) {
    p2.isMovingLeft = true;
    p4.isMovingRight = true;
    println("moving left");
  }

  if (p2Val1 > 400 && p2Val1 < 600) {
    p2.isMovingLeft = false;
    p2.isMovingRight = false;
    p4.isMovingLeft = false;
    p4.isMovingRight = false;
  }

  if (p2Val3 == 0) {
    p2Val3=1;
  }

  if (p2Val4 == 1) {
    p2.swing(b2);
    p4.swing2(b3);
    p4.swing(b3);
    p2.collided = false; //only allows the player to swing once
    p4.collided = false;
  }
}

void serialEvent(Serial myPort) {
  if (firstContact == false) {
    //put the incoming data into a String - 
    //the '\n' is our end delimiter indicating the end of a complete packet
    String val = myPort.readStringUntil('\n');
    //make sure our data isn't empty before continuing
    if (val != null) {
      //trim whitespace and formatting characters (like carriage return)
      val = trim(val);
      //println(val);

      //look for our 'A' string to start the handshake
      //if it's there, clear the buffer, and send a request for data
      if (firstContact == false) {
        if (val.equals("A")) {
          myPort.clear();
          firstContact = true;
          myPort.write("A");
          println("contact");
        }
      }
    }
  }
}

void serialEvent1(Serial myPort) {
  if (firstContact1 == false) {
    //put the incoming data into a String - 
    //the '\n' is our end delimiter indicating the end of a complete packet
    String val = myPort.readStringUntil('\n');
    //make sure our data isn't empty before continuing
    if (val != null) {
      //trim whitespace and formatting characters (like carriage return)
      val = trim(val);
      //println(val);

      //look for our 'A' string to start the handshake
      //if it's there, clear the buffer, and send a request for data
      if (firstContact1 == false) {
        if (val.equals("A")) {
          myPort.clear();
          firstContact1 = true;
          myPort.write("A");
          println("contact");
        }
      }
    }
  }
}

void serialEvent2(Serial myPort) {
  if (firstContact2 == false) {
    //put the incoming data into a String - 
    //the '\n' is our end delimiter indicating the end of a complete packet
    String val = myPort.readStringUntil('\n');
    //make sure our data isn't empty before continuing
    if (val != null) {
      //trim whitespace and formatting characters (like carriage return)
      val = trim(val);
      //println(val);

      //look for our 'A' string to start the handshake
      //if it's there, clear the buffer, and send a request for data
      if (firstContact2 == false) {
        if (val.equals("A")) {
          myPort.clear();
          firstContact2 = true;
          myPort.write("A");
          println("contact");
        }
      }
    }
  }
}

void buttonSelect() {
  recieve1();
  if (p1Val1 >= xThreshHigh) {
    left = false;
    right = true;
  }
  if (p1Val2 >= yThreshHigh) {
    up = false;
    down = true;
  }
  if (p1Val1 <= xThreshLow) {
    left = true;
    right = false;
  }
  if (p1Val2 >= yThreshLow) {
    up = true;
    down = false;
  }
}

void recieve1() {

  char startChar = '<';
  char endChar = '>';

  //while something is available over the serial port
  while (port1.available() > 0) {
    char currentChar = port1.readChar();


    // if the char I just read matches my startChar, then read the message
    if (currentChar == startChar) {
      message1 = port1.readStringUntil(endChar);

      if (message1!= null) {
        parseMessage1();
        println(p1Val1, " ", p1Val2, " ", p1Val3, " ", p1Val4);
      }
    }
  }
}

void recieve2() {

  char startChar = '<';
  char endChar = '>';

  //while something is available over the serial port
  while (port2.available() > 0) {
    char currentChar = port2.readChar();


    // if the char I just read matches my startChar, then read the message
    if (currentChar == startChar) {
      message2 = port2.readStringUntil(endChar);

      if (message2!= null) {
        parseMessage2();
        println(p2Val1, " ", p2Val2, " ", p2Val3); //TODO: ADD p2Val4
      }
    }
  }
}

void parseMessage1() {
  // ex message: "10,20,30>"
  //get the index of the first comma
  int commaIndex = message1.indexOf(',');
  // get the substring of the first number
  String mySubstring = message1.substring(0, commaIndex);
  // println(mySubstring);
  // convert string to int and save to my var
  p1Val1 = int (mySubstring);


  // change message so it does not have first number
  // or the first comma
  message1 = message1.substring(commaIndex+1);
  println(message1);
  //get the index of the first comma
  commaIndex = message1.indexOf(',');
  // get the substring of the first number
  mySubstring = message1.substring(0, commaIndex);
  p1Val2 = int(mySubstring);
  //println(val2);


  message1 = message1.substring(commaIndex+1);
  println(message1);
  //get the index of the first comma
  commaIndex = message1.indexOf(',');
  // get the substring of the first number
  mySubstring = message1.substring(0, commaIndex);
  p1Val3 = int(mySubstring);


  // change message so it does not have the second number
  // or the second comma
  message1 = message1.substring(commaIndex+1);
  println(message1); 
  //get the index of the first comma
  int endCharIndex = message1.indexOf('>');
  // get the substring of the first number
  mySubstring = message1.substring(0, endCharIndex);
  p1Val4 = int(mySubstring);
}

void parseMessage2() {
  int commaIndex = message2.indexOf(',');
  // get the substring of the first number
  String mySubstring = message2.substring(0, commaIndex);
  // println(mySubstring);
  // convert string to int and save to my var
  p2Val1 = int (mySubstring);


  // change message so it does not have first number
  // or the first comma
  message2 = message2.substring(commaIndex+1);
  println(message2);
  //get the index of the first comma
  commaIndex = message2.indexOf(',');
  // get the substring of the first number
  mySubstring = message2.substring(0, commaIndex);
  p2Val2 = int(mySubstring);
  //println(val2);


  message2 = message2.substring(commaIndex+1);
  println(message2);
  //get the index of the first comma
  commaIndex = message2.indexOf(',');
  // get the substring of the first number
  mySubstring = message2.substring(0, commaIndex);
  p2Val3 = int(mySubstring);


  // change message so it does not have the second number
  // or the second comma
  message2 = message2.substring(commaIndex+1);
  println(message2); 
  //get the index of the first comma
  int endCharIndex = message2.indexOf('>');
  // get the substring of the first number
  mySubstring = message2.substring(0, endCharIndex);
  p2Val4 = int(mySubstring);
}
