/*     
   _
 /_ /  SEGMENTOS
/_ /

*/
//Paso 1

//                    a  b  c  d  e  f  g
//const int pins[7] = { 3, 4, 5, 6, 7, 9, 10 };        //For Arduino microcontroller
//const int pins[7] = {D2, D1, D3, D4, D6,D7, D8};  // For ESP8266 microcontroller
const int pins[7] = {23, 17, 18, 19, 21, 22, 5};    // For ESP32 microcontroller
//Paso 2
const byte numbersDisplayAnode[10] = {0b1000000,     //0 0x40
                          0b1111001,          //1 0x79
                          0b0100100,          //2 0x24
                          0b0110000,          //3 0x30
                          0b0011001,          //4 0x19
                          0b0010010,          //5 0x12
                          0b0000010,          //6 0x02
                          0b1111000,          //7 0x78
                          0b0000000,          //8 0x00
                          0b0010000};         //9 0x10

 const byte numbersDisplayKatode[10] = {0b0111111,     //0 0x3F
                          0b0000110,          //1 0x06
                          0b1011011,          //2 0x5B
                          0b1001111,          //3 0x4F
                          0b1100110,          //4 0x66
                          0b1101101,          //5 0x6D
                          0b1111101,          //6 0x7D
                          0b0000111,          //7 0x07
                          0b1111111,          //8 0x7F
                          0b1101111};         //9 0x6F


void setup() {
  //Paso 3
  for(int i = 0; i < 7; i++) {
    pinMode(pins[i], OUTPUT);  
  }

  //Paso 5
  lightSegments(0);
}

void loop() {
  //Paso 6
  for(int i = 0; i < 10; i++) {
    lightSegments(i);
    delay(1000);
  }
}

//Paso 4
void lightSegments(int number) {
  byte numberBit = numbersDisplayAnode[number];
  for (int i = 0; i < 7; i++)  {
    int bit = bitRead(numberBit, i);
    digitalWrite(pins[i], bit);
  }
}
