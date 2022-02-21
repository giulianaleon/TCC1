#include <AudioFrequencyMeter.h>
#include <SerialCommand.h>

AudioFrequencyMeter meter;

float valToSend = 3.14159;
byte bytesToSend[sizeof(float)];
char szChar[20];

void setup() {

  Serial.begin(115200);
  Serial1.begin(115200);
  Serial.flush();
  Serial1.flush();

  meter.setBandwidth(50, 200);    // Ignore frequency out of this range
  meter.begin(A1, 5000);             // Initialize A0 at sample rate of 45 kHz
}

void loop() {

  float frequency = meter.getFrequency();

  if(frequency > 0){

    memcpy( bytesToSend, (uint8_t *)&frequency, sizeof( float ) );
    for( uint8_t i=0; i<sizeof( float ); i++ )
    {
        sprintf( szChar, "0x%02X ", bytesToSend[i] );
        //Serial.print( szChar );
        
    }//if

    //String convert = String (frequency, 0);
    // Serial1.print(frequency);
    Serial.write(szChar);
    Serial1.print("\n");
  
    if(Serial1.available()){
      Serial.write(Serial1.read());
    }
  }
  delay(2000);
}
