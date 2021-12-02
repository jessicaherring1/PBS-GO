// Adafruit_NeoMatrix example for single NeoPixel Shield.
// Scrolls 'Howdy' across the matrix in a portrait (vertical) orientation.

#include <Adafruit_GFX.h>
#include <Adafruit_NeoMatrix.h>
#include <Adafruit_NeoPixel.h>
#ifndef PSTR
#define PSTR // Make Arduino Due happy
#endif

#define PIN 6
#define PIN2 5

String inMessage;
String score;

int p1Score = 0;
int p2Score = 0;
//String p1ScoreString;
//String p2ScoreString;

// MATRIX DECLARATION:
// Parameter 1 = width of NeoPixel matrix
// Parameter 2 = height of matrix
// Parameter 3 = pin number (most are valid)
// Parameter 4 = matrix layout flags, add together as needed:
//   NEO_MATRIX_TOP, NEO_MATRIX_BOTTOM, NEO_MATRIX_LEFT, NEO_MATRIX_RIGHT:
//     Position of the FIRST LED in the matrix; pick two, e.g.
//     NEO_MATRIX_TOP + NEO_MATRIX_LEFT for the top-left corner.
//   NEO_MATRIX_ROWS, NEO_MATRIX_COLUMNS: LEDs are arranged in horizontal
//     rows or in vertical columns, respectively; pick one or the other.
//   NEO_MATRIX_PROGRESSIVE, NEO_MATRIX_ZIGZAG: all rows/columns proceed
//     in the same order, or alternate lines reverse direction; pick one.
//   See example below for these values in action.
// Parameter 5 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_GRBW    Pixels are wired for GRBW bitstream (RGB+W NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)


// Example for NeoPixel Shield.  In this application we'd like to use it
// as a 5x8 tall matrix, with the USB port positioned at the top of the
// Arduino.  When held that way, the first pixel is at the top right, and
// lines are arranged in columns, progressive order.  The shield uses
// 800 KHz (v2) pixels that expect GRB color data.
Adafruit_NeoMatrix matrix1 = Adafruit_NeoMatrix(8, 8, PIN,
                             NEO_MATRIX_TOP   + NEO_MATRIX_LEFT +
                             NEO_MATRIX_COLUMNS + NEO_MATRIX_ZIGZAG,
                             NEO_GRB            + NEO_KHZ800);

Adafruit_NeoMatrix matrix2 = Adafruit_NeoMatrix(8, 8, PIN2,
                             NEO_MATRIX_TOP    + NEO_MATRIX_LEFT +
                             NEO_MATRIX_COLUMNS + NEO_MATRIX_ZIGZAG,
                             NEO_GRB            + NEO_KHZ800);

const uint16_t colors[] = {
  matrix1.Color(0, 0, 255), matrix1.Color(255, 0, 255), matrix1.Color(255, 0, 0)
};

const uint16_t colors2[] = {
  matrix2.Color(0, 255, 0), matrix2.Color(255, 0, 0), matrix2.Color(0, 0, 255)
};

void setup() {
  Serial.begin(9600);
  matrix1.begin();
  matrix1.setTextWrap(false);
  matrix1.setBrightness(40);
  matrix1.setTextColor(colors[0]);

  matrix2.begin();
  matrix2.setTextWrap(false);
  matrix2.setBrightness(40);
  matrix2.setTextColor(colors2[0]);
}

void loop() {
  receive();
  //    matrix.print(F("jess"));

  //matrix 1
  if (p1Score == 15) {
    matrix1.setTextColor(colors[1]);
    matrix1.fillScreen(0);
    matrix1.setCursor(0, 0);
    matrix1.print("");
    matrix1.show();

    matrix2.setTextColor(colors[0]);
    matrix2.fillScreen(0);
    matrix2.setCursor(1, 0);
    matrix2.print(p2Score);
    matrix2.show();
  } else {
    
    matrix1.setTextColor(colors[0]);
    matrix1.fillScreen(0);
    matrix1.setCursor(1, 0);
    matrix1.print(p1Score);
    matrix1.show();
  

  //matrix2
  matrix2.setTextColor(colors2[0]);
  matrix2.fillScreen(0);
  matrix2.setCursor(1, 0);
  matrix2.print(p2Score);
  matrix2.show();
  }

}

void receive() {
  char startChar = '?';
  char endChar = '!';

  if (Serial.available() > 0) {
    char currentChar = Serial.read();
    if (currentChar == startChar) {
      inMessage = Serial.readStringUntil(endChar);

      //  if inMessage != null (null = "\0")
      if (inMessage != "\0") {
        parseMessage();
      }

    }
  }
}


void parseMessage() {
  int commaIndex = inMessage.indexOf(',');
  p1Score = inMessage.substring(0, commaIndex).toInt();

  //Serial.println(p1Score);

  p2Score = inMessage.substring(commaIndex + 1).toInt();

  //Serial.println(p2Score);
  //score = String(p1Score) + "--" + String(p2Score); //+ String(p1Score) + String(p2Score);



  //p1ScoreString = String(p1Score);
  //p2ScoreString = String(p2Score);
}
