// making my new class Ball
class Ball {
  // class variables
  int x;
  int y;
  int d;
  int xSpeed;
  int ySpeed;
  color c;

  //hitbox
  int bTop;
  int bBottom;
  int bLeft;
  int bRight;

  // make my constructor function
  Ball(int tempX, int tempY) {
    x = tempX;
    y = tempY;
    d = 20;
    xSpeed = 4;
    ySpeed = 4;
    c = color(255, 255, 255);
    bTop = y - d/2;
    bBottom = y + d/2;
    bRight = x + d/2;
    bLeft = x - d/2;
  }

  //FUNCTIONS

  //draws the ball
  void render() {
    fill(c);
    circle(x, y, d);
  }

  //moves the ball
  void move() {
    x = x + xSpeed;
    y = y - ySpeed;
    bTop = y - d/2;
    bBottom = y + d/2;
    bRight = x + d/2;
    bLeft = x - d/2;
  }
  
   // moves the ball
   //for the b2 ball
  void move1() {
    x = x + xSpeed;
    y = y - ySpeed;
    bTop = y - d/2;
    bBottom = y + d/2;
    bRight = x + d/2;
    bLeft = x - d/2;
  }


  // checks if the ball hit the wall, and flips the direction if it hits the wall
  // only left and right wall
  void ballWallDetect() {
    //left wall
    if (x <= 0 + c/2) {
      xSpeed = abs(xSpeed * -1);
    }
    //right wall
    else if (x >= width - d/2) {
      xSpeed = -abs(xSpeed * -1);
    }
  }
  
   // checks if the ball hit the wall, and flips the direction if it hits the wall
  // only left wall and midpoint
  void ballWallDetect1() {
    //left wall
    if (x <= 0 + d/2) {
      xSpeed = abs(xSpeed * -1);
    }
    //midpoint
    else if (x >= width/2 - d/2) {
      xSpeed = -abs(xSpeed * -1);
    }
  }

 // checks if the ball hit the wall, and flips the direction if it hits the wall
  // only midpoint and right wall
  void ballWallDetect2() {
    //lmidpoint
    if (x <= width/2 + d/2) {
      xSpeed = abs(xSpeed * -1);
    }
    //right wall
    else if (x >= width - d/2) {
      xSpeed = -abs(xSpeed * -1);
    }
  }
}
