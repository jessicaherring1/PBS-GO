//making my new class player
class Player {
  // class variables
  int x;
  int y;
  int w;
  int h;
  int speed;
  color c;

  //movement
  boolean isMovingLeft;
  boolean isMovingRight;
  boolean collided;

  //hitbox
  int pTop;
  int pBottom;
  int pRight;
  int pLeft;

  //scoring
  int score;
  int scoreX;
  int scoreY;
  int winScore;

  //making my constructor function
  Player(int tempX, int tempY, color tempC, int tempScoreX, int tempScoreY, int tempWinScore ) {
    x = tempX;
    y = tempY;
    w = 70;
    h = 10;
    speed = 8;
    c = tempC;
    isMovingLeft = false;
    isMovingRight = false;
    pTop = y ;
    pBottom = y + h ;
    pRight = x + w;
    pLeft = x;
    score = 0;
    scoreX = tempScoreX;
    scoreY = tempScoreY;
    winScore = tempWinScore;
  }

 // Functions

  //draws the ball
  void render() {
    fill(c);
    rect(x, y, w, h);
    if (y >= height/ 2) {
      pTop = y - 50;
      pBottom = y + h;
      pRight = x + w;
      pLeft = x;
    }
    if (y <= height/ 2) {
      pTop = y ;
      pBottom = y + h + 50;
      pRight = x + w;
      pLeft = x;
    }
  }


  // moves the player to the left
  void moveLeft() {
    if (isMovingLeft == true && x > 0  ) {
      x = x - speed;
    }
  }

  // moves the player to the right 
  void moveRight() {
    if (isMovingRight == true && x + w < width) {
      x = x + speed;
    }
  }

  // moves the player to the left on the first half of the screen
  void moveLeft1() {
    if (isMovingLeft == true && x > 0  ) {
      x = x - speed;
    }
  }

  // moves the player to the right on the first half of the screen
  void moveRight1() {
    if (isMovingRight == true && x + w < width/2) {
      x = x + speed;
    }
  }

  // moves the player to the left on the second half of the screen
  void moveLeft2() {
    if (isMovingLeft == true && x > width/2  ) {
      x = x - speed;
    }
  }

  // moves the player to the right on the first half of the screen
  void moveRight2() {
    if (isMovingRight == true && x + w < width) {
      x = x + speed;
    }
  }

  //// allows the player to swing at the ball
  //// collision if statements
  void swing(Ball aball) {
    if (pTop < aball.bBottom) {
      if (pBottom > aball.bTop) {
        if (pRight > aball.bLeft) {
          if (pLeft < aball.bRight) {
            if (y >= height/2) {
              aball.ySpeed = abs(aball.ySpeed); 
              aball.xSpeed = aball.xSpeed;
              println("swingUp");
              println(aball.ySpeed);
            }
            if (y <= height/2) {
              aball.ySpeed =  - abs(aball.ySpeed); 
              aball.xSpeed = aball.xSpeed;
              println("swing");
            }
          }
        }
      }
    }
  }

  //// allows the player to swing at the ball
  //// collision if statements
  // for reflection players
  void swing2(Ball aball) {
    if (pTop < aball.bBottom) {
      if (pBottom > aball.bTop) {
        if (pRight > aball.bLeft) {
          if (pLeft < aball.bRight) {
            if (y <= height/2) {
              aball.ySpeed = abs(aball.ySpeed); 
              aball.xSpeed = aball.xSpeed;
               aball.ySpeed += 0.2;

              println("swing2Down");
              //println(aball.ySpeed);
            }
            if (y >= height/2) {
              aball.ySpeed = - abs(aball.ySpeed); 
              aball.xSpeed = aball.xSpeed;
              aball.ySpeed += 0.2;

              println(y);
              println(aball.ySpeed);
              println("swing2Up");
            }
          }
        }
      }
    }
  }

  // keeps track of the player's score
  void scoring(Ball aball) {
    fill(c);
    textSize(128);
    text(score, scoreX, scoreY);
    if (score == winScore) {
      aball.xSpeed = 0;
      aball.ySpeed = 0;
      fill(c);
      text ("WINNER", width/4, height/2);
      text ("press 'h' to go home", 0, height/2 + 100);
    }
  }
}
