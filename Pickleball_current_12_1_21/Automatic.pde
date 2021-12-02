// making my new class Automatic
class Automatic {

  // class variables
  float x;
  float y;
  int w;
  int h;
  color c;

  //hitbox
  int aTop;
  int aBottom;
  int aRight;
  int aLeft;

  //scoring
  int score;
  int scoreX;
  int scoreY;
  int winScore;


  float easing ;
  float chanceToSwing;

  //make my constructor function
  Automatic(int tempX, int tempY, color tempC, int tempScoreX, int tempScoreY, int tempWinScore, float tempEase, float tempChance) {
    x = tempX;
    y = tempY;
    w = 70;
    h = 10;
    c = tempC;
    aTop = int(y);
    aBottom = int(y) + h;
    aRight = int(x) + w;
    aLeft = int(x);
    score = 0;
    scoreX = tempScoreX;
    scoreY = tempScoreY;
    winScore = tempWinScore;
    easing = tempEase;
    chanceToSwing = tempChance;
  }

  //Functions
  void render() {
    fill(c);
    rect(x, y, w, h);
    aTop = int(y);
    aBottom = int(y) + h;
    aRight = int(x) + w;
    aLeft = int(x);
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
    }
  }

  void ease(Ball aball) {
    float targetX = aball.x;
    float dx = targetX - x;
    x += dx * easing;
  }

  void hit(Ball aball) {
    if (aTop < aball.bBottom) {
      if (aBottom > aball.bTop) {
        if (aRight > aball.bLeft) {
          if (aLeft < aball.bRight) {
            float diceRoll = random(0, 1);
            if (diceRoll < chanceToSwing) {
              if (y <= height/2) {
                aball.ySpeed = -abs(aball.ySpeed); 
                aball.xSpeed = aball.xSpeed;
              }
              if (y >= height/2) {
                aball.ySpeed = abs(aball.ySpeed); 
                aball.xSpeed = aball.xSpeed;
              }
            }
          }
        }
      }
    }
  }
}
