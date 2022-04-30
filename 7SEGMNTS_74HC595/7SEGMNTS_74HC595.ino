
// for Arduino microcontroller
int clockPin = 6;
int latchPin = 5;
int dataPin = 4;

// for ESP8266 microcontroller
//int clockPin = D8;
//int latchPin = D7;
//int dataPin = D6;

// for ESP32 microcontroller
//int clockPin = 4;
//int latchPin = 0;
//int dataPin = 2;

int numCC[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F}; //NUMEROS PARA CATODO COMUN
int numAC[] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10}; //NUMEROS PARA ANODO COMUN
void setup() {
  pinMode(clockPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
}
//Note para 7SEG CC use first low and before high, for AC es alrevez
void loop() {
  for (int i = 0; i<10; i++) {
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, MSBFIRST, numCC[i]);
    digitalWrite(latchPin, HIGH);
    delay(1000);
  }
}
