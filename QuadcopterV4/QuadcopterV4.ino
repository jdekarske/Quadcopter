
/*
Jason Dekarske
This version attempts to control individual motors
TODO:
parseInt alternative
radio.writefast
error checking ...I did some in Matlab
*/

#include <SPI.h>
#include "RF24.h"
#include <Servo.h>

/*************** For Timing Things ************************/
long now;
/**********************************************************/


/********************* Config *****************************/
/* 1 is transmitter module, 0 is quadcopter */
bool radioNumber = 1;
/* Set up radio on pins 7 and 8 for CE,CS */
RF24 radio(4,2);
byte addresses[][6] = {"1Node","2Node"};
/* Motors */
Servo e1, e2, e3, e4;
int m1, m2, m3, m4;
char beginchar; //stores motor delimiter
struct payload {
  int m1 = 0;
  int m2 = 0;
  int m3 = 0;
  int m4 = 0;
};
int gpin = 4;
int bpin = 10;
int rpin = 2;
float battery = 0.0;

/**********************************************************/
char buff[3];
char rec;
int readSerial(){
    for (int i=0; i<4; i++) {
      rec = Serial.read();
      buff[i] = rec;
    }  
  return(atoi(buff));
}

void setup() {
  Serial.begin(115200);
  e1.attach(3);
  e2.attach(5);
  e3.attach(6);
  e4.attach(9);
  e1.writeMicroseconds(1000); //Start with low speed in case they were left on
  e2.writeMicroseconds(1000);
  e3.writeMicroseconds(1000);
  e4.writeMicroseconds(1000);
  Serial.println("Layout:");
  Serial.println("1        2"); //may not be right
  Serial.println("|        |");
  Serial.println("+--------+");
  Serial.println("|        |");
  Serial.println("4        3");
/***************** Battery Stuff **************************/

  now = micros();
  pinMode(gpin, OUTPUT);
  pinMode(bpin, OUTPUT);
  pinMode(rpin, OUTPUT);

/**********************************************************/  
  radio.begin();
  //RF24_PA_MAX is default. Change with power issues
  radio.setPALevel(RF24_PA_LOW);
  
  // Open a writing and reading pipe on each radio, with opposite addresses
  if(radioNumber){
    radio.openWritingPipe(addresses[1]);
    radio.openReadingPipe(1,addresses[0]);
  }else{
    radio.openWritingPipe(addresses[0]);
    radio.openReadingPipe(1,addresses[1]);
  }

  // Start the radio listening for data
  if(radioNumber){
    radio.stopListening();
  }else{
    radio.startListening();
        e1.writeMicroseconds(1000);
        e2.writeMicroseconds(1000);
        e3.writeMicroseconds(1000);
        e4.writeMicroseconds(1000);
  }
  //radio.enableDynamicAck(); //We don't need acknowledged packets...we wanna go FAST
  //radio.setAutoAck();
  Serial.println("Ready! Control speed with 1000-2000");
}

void loop() {
  
/****************** Transmitter ***************************/  
if (radioNumber == 1)  {
    
    if(Serial.available() >= 17){ //look for start character, take 4 motor speeds, dump the rest
      //now = micros();
      beginchar = Serial.read();
      if(beginchar == 'a'){    
        payload speeds; 
        speeds.m1 = readSerial(); //This should be improved 
        speeds.m2 = readSerial();
        speeds.m3 = readSerial();
        speeds.m4 = readSerial();
        //while(Serial.available() > 0) { //clear out serial buffer just in case, this might be screwing up the buffer, consider adding newline tag
        //  Serial.read();
        //}
        Serial.print("Now sending: ");
        Serial.print(speeds.m1);
        Serial.print(", ");
        Serial.print(speeds.m2);
        Serial.print(", ");
        Serial.print(speeds.m3);
        Serial.print(", ");
        Serial.println(speeds.m4);
        if (!radio.write( &speeds, sizeof(payload))){    
          Serial.println("failed");
        }else{
          //Serial.println(micros()-now);
        }
      }
    }
  }

/****************** Quadcopter ***************************/

  if ( radioNumber == 0 )
  { 
      while (radio.available()) {                                   // While there is data ready      
        payload speeds;
        radio.read( &speeds, sizeof(payload) );
        e1.writeMicroseconds(speeds.m1);
        e2.writeMicroseconds(speeds.m2);
        e3.writeMicroseconds(speeds.m3);
        e4.writeMicroseconds(speeds.m4);
      }
//      if (micros()-now >= 5 * 1000000){ //check battery every 5 seconds
//        //battery = analogRead(A4) * 4.75*3/1024.0;
//        Serial.println(battery);
//        now = micros();
//        if (battery > 11.75){
//          digitalWrite(gpin, HIGH);
//        }
//        else if (battery > 11) {
//          digitalWrite(bpin, HIGH);
//        }
//        else if (battery > 10) {
//          digitalWrite(rpin, HIGH);
//        }
//        else {
//        while(1){//battery error
//          e1.writeMicroseconds(1000);
//          e2.writeMicroseconds(1000);
//          e3.writeMicroseconds(1000);
//          e4.writeMicroseconds(1000);
//          digitalWrite(rpin, HIGH);
//          delay(100);
//          digitalWrite(rpin, LOW);
//          delay(100);
//          if ((analogRead(A4) * 5/1024.0)>1){
//            break;
//          }
//        }
//      }
//
//
//      }
//      if (micros()-now >= 2.5 * 1000000){ //threading the led
//        digitalWrite(gpin, LOW);
//        digitalWrite(bpin, LOW);
//        digitalWrite(rpin, LOW);   
//      }

 }
 
} 

