//NEOPIXELS
#include <Adafruit_NeoPixel.h>
Adafruit_NeoPixel strip(10, 9);
uint32_t green = strip.Color(0,255,0);

//JOYSTICK
#define joyX A2
#define joyY A3
#define but 3

boolean buttonState = false; 
boolean prevButtonState = false;


//ACCELEROMETER

#include <Wire.h>   
#include "SparkFun_MMA8452Q.h"
MMA8452Q accel;

boolean swung;
float currentValX;
float prevValX;
float currentValY;
float prevValY;

//MOTOR
int motorPin = 3;
String inMessage;
int motor;


void setup(){
  Serial.begin(9600);

  strip.begin();
  strip.clear();
  strip.show();


  pinMode(but, INPUT);
  digitalWrite(but, HIGH);

  Wire.begin();

  if (accel.begin() == false) {
    Serial.println("Not Connected. Please check connections and read the hookup guide.");
    while (1);
  }

  pinMode(motorPin, OUTPUT);

  establishContact();
}




void loop(){
for(int i=0; i<strip.numPixels();i++){
  strip.setPixelColor(i, green);
  strip.show();
}
  
  sendData();
  receive();

  if (motor==0){
    digitalWrite(motorPin, LOW);
  } else if (motor ==1){
    digitalWrite(motorPin, HIGH); //vibrate
    delay(1000);
    digitalWrite(motorPin, LOW);
  }

 
}


void sendData(){
  isSwinging();
 
  String joyXReading = String(analogRead(joyX));
  String joyYReading = String(analogRead(joyY));
  String butReading = String(digitalRead(but)); 

  String printThis = "<"+joyXReading+","+joyYReading+","+butReading+","+swung+">";

  Serial.println(printThis);
}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(300);
  }
}

boolean debounce(int aButPin, boolean aPrevState) {
  //get the debouced signal
  boolean aButtonState = digitalRead(aButPin);
  if (aPrevState != aButtonState) {
    delay(50);
  }
  return aButtonState;
}

boolean isSwinging() {
  String printThis;
  
  if (accel.available()) {
    currentValY = (accel.getCalculatedY());
    currentValX = (accel.getCalculatedX());
  }

  if ((abs(currentValY - prevValY) >= .5) || (abs(currentValX - prevValX) >= .5)) {
    swung = true;
  } else {
    swung = false;
  }
  
  prevValY = currentValY;
  prevValX = currentValX;
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
        //parseMessage();
        motor = inMessage.toInt();
        //Serial.println(inMessage);
      }

    }
  }
}
