#include <Servo.h>


long value = 0; // set values you need to zero
long val = 0;

Servo e1, e2, e3, e4; //Create as much as Servoobject you want. You can controll 2 or more Servos at the same time

void setup() {
  
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);    // start serial at 9600 baud
  e1.attach(3);    // attached to pin 9 I just do this with 1 Servo
  e2.attach(6);
  e3.attach(5);
  e4.attach(9);
  digitalWrite(LED_BUILTIN, HIGH);
  e1.write(2000);   //throttle high
  e2.write(2000);
  e3.write(2000);
  e4.write(2000);
  delay(10000);
  e1.write(1250);   //throttle low
  e2.write(1250);
  e3.write(1250);
  e4.write(1250);
  delay(3000);  

}

void loop() {

//First connect your ESC WITHOUT Arming. Then Open Serial and follo Instructions
 
  e1.writeMicroseconds(value);
  e2.writeMicroseconds(value);
  e3.writeMicroseconds(value);
  e4.writeMicroseconds(value);
  delay(15);
  if(Serial.available()) 
    val = Serial.parseInt();    // Parse an Integer from Serial
    value = map(val, 0, 100, 1250, 2000);

}
